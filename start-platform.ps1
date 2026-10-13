# ═══════════════════════════════════════════════════════════════
# BellosData Platform — Local Lakehouse Startup Script
# Starts Apache Airflow 3.2.1 cluster in one command
# ═══════════════════════════════════════════════════════════════
#
# Usage:
#   .\start-platform.ps1          # Start Airflow cluster
#   .\start-platform.ps1 -Stop    # Stop Airflow cluster
#
# ═══════════════════════════════════════════════════════════════

param(
    [switch]$Stop
)

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "══════════════════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host "  BellosData Platform — S3 Delta Lakehouse Engine" -ForegroundColor Cyan
Write-Host "══════════════════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host ""

$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($Stop) {
    Write-Host "Stopping Airflow lakehouse services..." -ForegroundColor Yellow

    Push-Location "$ROOT\airflow"
    docker compose down
    Pop-Location

    Write-Host ""
    Write-Host "All services stopped." -ForegroundColor Green
    exit 0
}

# ── Start Airflow ──
Write-Host "Starting Apache Airflow 3.2.1 cluster..." -ForegroundColor Yellow
Push-Location "$ROOT\airflow"
docker compose up -d
Pop-Location

# ── Health Check ──
Write-Host ""
Write-Host "Waiting for services to start..." -ForegroundColor DarkGray
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "══════════════════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host "  BellosData Lakehouse Platform is RUNNING" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  Airflow UI:          " -NoNewline; Write-Host "http://localhost:8081" -ForegroundColor Cyan
Write-Host "  AWS Glue Catalog:    " -NoNewline; Write-Host "AWS Console -> Glue -> Databases -> bellosdata" -ForegroundColor Cyan
Write-Host "  Redshift Serverless: " -NoNewline; Write-Host "AWS Console -> Redshift Query Editor v2" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Stop all services:   " -NoNewline; Write-Host ".\start-platform.ps1 -Stop" -ForegroundColor DarkYellow
Write-Host ""
