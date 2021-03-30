# What's This?

This is a repository containing a description of my personal infrastructure managed by Terraform.

# Why This?

I've been experimenting with a number of cloud providers and I'm starting to lose track of where my money's going.

# How This?

Well, good question. All of these files are expressed in Hashicorp HCL for use with their tool
[`terraform`](https://github.com/hashicorp/terraform).

So, if you want to replicate this infrastructure for whatever reason, you'll need the `terraform` CLI. At the time of
writing I'm using v0.14.9 .

There are a couple of moving parts, so `terraform` alone may not be enough. I maintain infrastructure on
1. `AWS`
2. `GCP`
3. `Vultr`
4. `BackBlaze`

Each of these systems has their own credentials.

For making `terraform` easy to use with this repository I've included a `.envrc.template` file that you can use with 
[`direnv`](https://direnv.net/) for making a set of useful environment variables available to `terraform`. So, install 
`direnv` fill the template out with appropriate credentials/settings and then:

    mv .envrc.template .envrc
    direnv allow .

## AWS Notes

Note: Your AWS credentials may not have the appropriate permissions. I have been using the venerable tool 
[iamalive](https://github.com/iann0036/iamlive) to exactly capture the IAM permissions necessary for an AWS policy 
useful for managing *only* the AWS resources in this repository. So, if more types of resources are used then it will 
probably be necessary to change this IAM policy. The way I do this right now is a little iterative (read: painful) and 
it looks like this:

TTY1

    iamalive # start iamalive in CSM mode (`--mode=proxy` offers nothing extra)

TTY2

    direnv allow . # populate the environment with the `AWS_CSM_*` environment variables
    terraform apply -auto-approve # warning: this `auto-approve`s the configuration

Then:
1. Copy-paste the STDOUT of the `iamalive` (TTY1), a JSON IAM policy, into a custom policy on AWS (edit as JSON).
    - make sure the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` values are associated with a user which is attached 
    to this custom IAM policy
1. Run `terraform apply` again

At this point, `terraform apply` may work just fine (if you have all relevant IAM permissions in the policy) or, more 
likely, you still need to add a few permissions. These will be revealed as you repeat the above copy-paste and 
`terraform apply` steps repeatedly until you have all of the necessary IAM policies.

## GCP Notes

For GCP permissions it's sufficient to download a JSON file for a service role. From the GCP dashboard:
1. `IAM & Admin > Service Accounts > **click some service account address** > Keys > Add Key > Create New Key > JSON`

Then point `.envrc` to the downloaded JSON file. Keep this file safe.

## Vultr Notes
Vultr expsoses a **visible** plain text API key in the settings page of the account.

## BackBlaze Notes

Strictly speaking, currently, my only use for BackBlaze is using a B2 bucket to manage my `terraform` state for this 
repository. So, running `terraform` in my case requires access to BackBlaze. However, `terraform` doesn't support 
`BackBlaze` as a backend. However, `terraform` does support a generic HTTP(s) server as a backend. So, I wrote a 
[service](https://github.com/johnrichardrinehart/backblaze-terraform-backend-proxy) that satisfies the API specified by
`terraform` for HTTP(s) backends. So, I use that command with this repository, too. I run this locally on port `8080` 
and this value is in `main.tf` (`backend "http"`).

Since these credentials are not needed by `terraform` I maintain these credentials separately and run the
`backblaze-terraform-backend-proxy` like

    B2_KEY_ID="0123456789" B2_APP_KEY="ABCDEFGH//123456" ./server

# Summary

So, in summary, there is:
1. `backblaze-terraform-backend-proxy` running 
1. `terraform apply` running, whenever I want to apply infrastructure changes
1. `iamalive` whenever the AWS credentials used by `terraform` are missing IAM permissions (updating the AWS IAM policy as I go)