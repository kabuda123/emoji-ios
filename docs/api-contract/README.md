# API Contract Notes

This iOS repo currently targets backend contract v1 from `emoji/docs/api/contract-v1.md`.

## Base URL
- Local default: `http://localhost:8080`

## Implemented client areas
- Bootstrap config
- Email login and Apple placeholder login
- Template list/detail
- Upload policy request
- Generation create/detail polling
- History list/delete
- Credit balance and IAP verification

## Current limitations
- Apple sign-in SDK integration is not implemented yet.
- Real image upload is not implemented yet; the client only requests upload policy metadata.
- The Xcode project file is still a placeholder and must be regenerated on macOS before device builds.