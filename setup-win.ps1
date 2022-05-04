if (-Not ([Environment]::GetEnvironmentVariable("VAULT_ADDR"))) {
    [Environment]::SetEnvironmentVariable("VAULT_ADDR", "https://clotho.broadinstitute.org:8200", "User")
    echo "Set VAULT_ADDR"
}

if (-Not ([Environment]::GetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS"))) {
    [Environment]::SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "./output-build-config/housekeeping-service-account.json", "User")
    echo "Set GOOGLE_APPLICATION_CREDENTIALS"
}
