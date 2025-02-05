package testimpl

import (
	"testing"
	"time"
	"strings"
	"context"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	t.Run("TestLambdaWasInvoked", func(t *testing.T) {
		cloudwatchlogsClient := GetCloudWatchLogsClient(t)

		logGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "log_group_name")
		expectedMessage := terraform.Output(t, ctx.TerratestTerraformOptions(), "expected_message")

		// Query Cloudwatch Logs until we see the log line we're expecting, which indicates
		// that the schedule triggered the Lambda function. We'll retry for up to 10 minutes.
		var found bool
		for i := 0; i < 60; i++ {
			resp, err := cloudwatchlogsClient.FilterLogEvents(context.TODO(), &cloudwatchlogs.FilterLogEventsInput{
				LogGroupName: aws.String(logGroupName),
				FilterPattern: aws.String("Lambda function invoked"),
			})
			assert.NoErrorf(t, err, "Unable to get filtered log events, %v", err)

			for _, event := range resp.Events {
				if strings.Contains(*event.Message, "Lambda function invoked") {
					found = true
					// assert the log line contains the event from eventbridge
					assert.Contains(t, *event.Message, expectedMessage)
					break
				}
			}

			if found {
				break
			}
			time.Sleep(10 * time.Second)
		}

		assert.True(t, found, "Expected to find log entry with 'Lambda function invoked'")
	})

}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

func GetCloudWatchLogsClient(t *testing.T) *cloudwatchlogs.Client {
	cloudwatchlogsClient := cloudwatchlogs.NewFromConfig(GetAWSConfig(t))
	return cloudwatchlogsClient
}
