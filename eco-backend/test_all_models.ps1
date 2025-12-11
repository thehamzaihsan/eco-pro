# Test all YOLO models via API (PowerShell)

param(
    [string]$Image = "test_image.jpg",
    [string]$ApiUrl = "http://localhost:8000/api/classify/"
)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Testing All YOLO Models" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Image: $Image"
Write-Host "API URL: $ApiUrl"
Write-Host ""

# Check if image exists
if (-not (Test-Path $Image)) {
    Write-Host "Error: Image file '$Image' not found!" -ForegroundColor Red
    exit 1
}

$models = @(
    @{Key="yolov11m-3class"; Name="YOLOv11m (3 Classes)"},
    @{Key="yolov11n-12class"; Name="YOLOv11n (12 Classes) - DEFAULT"},
    @{Key="yolov8n-3class"; Name="YOLOv8n (3 Classes) - Legacy"}
)

$counter = 1

# Test each model
foreach ($model in $models) {
    Write-Host "$counter. Testing $($model.Name)..." -ForegroundColor Yellow
    Write-Host "--------------------------------------"
    
    try {
        $form = @{
            image = Get-Item -Path $Image
            model = $model.Key
        }
        
        $response = Invoke-RestMethod -Uri $ApiUrl -Method Post -Form $form
        $response | ConvertTo-Json -Depth 10 | Write-Host
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    $counter++
}

# Test default (no model specified)
Write-Host "$counter. Testing Default Model (no model param)..." -ForegroundColor Yellow
Write-Host "--------------------------------------"
try {
    $form = @{
        image = Get-Item -Path $Image
    }
    
    $response = Invoke-RestMethod -Uri $ApiUrl -Method Post -Form $form
    $response | ConvertTo-Json -Depth 10 | Write-Host
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
Write-Host ""
$counter++

# List available models
Write-Host "$counter. Listing Available Models..." -ForegroundColor Yellow
Write-Host "--------------------------------------"
try {
    $modelsUrl = $ApiUrl -replace '/classify/', '/models/'
    $response = Invoke-RestMethod -Uri $modelsUrl -Method Get
    $response | ConvertTo-Json -Depth 10 | Write-Host
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "All tests completed!" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
