global DelveWebhookURLFile := A_ScriptDir "\Settings\WebhookURL.txt"
global DelveWebhookScreenshotEnabled := true
global DelveWebhookScreenshotFile := A_ScriptDir "\Settings\WebhookScreenshot.txt"

if FileExist(DelveWebhookScreenshotFile)
    DelveWebhookScreenshotEnabled := (Trim(FileRead(DelveWebhookScreenshotFile, "UTF-8")) = "1")

ShowDelveWebhookSetup() {
    webhookGui := Gui("+AlwaysOnTop")
    webhookGui.Title := "Delve Webhook"
    webhookGui.BackColor := "0x141417"
    webhookGui.SetFont("s10 cWhite", "Segoe UI")
    webhookGui.Add("Text", "w420", "Discord Webhook URL")
    webhookURLBox := webhookGui.Add("Edit", "w420 h24 cff5081", "")
    if FileExist(DelveWebhookURLFile)
        webhookURLBox.Text := FileRead(DelveWebhookURLFile, "UTF-8")
    screenshotBox := webhookGui.Add("Checkbox",
        "w420 h24 " (DelveWebhookScreenshotEnabled ? "Checked" : ""),
        "Send Roblox screenshot with every run")
    screenshotBox.OnEvent("Click", (*) => DelveWebhookScreenshotEnabled := screenshotBox.Value)

    saveButton := webhookGui.Add("Button", "w120 h28", "Save")
    saveButton.OnEvent("Click", (*) => SaveDelveWebhookConfig(webhookURLBox.Text, screenshotBox.Value))
    testButton := webhookGui.Add("Button", "x+10 wp h28", "Send Test")
    testButton.OnEvent("Click", (*) => DelveSendWebhookTest())
    closeButton := webhookGui.Add("Button", "x+10 wp h28", "Close")
    closeButton.OnEvent("Click", (*) => webhookGui.Destroy())
    webhookGui.Show("w440")
}

SaveDelveWebhookConfig(url, screenshotEnabled) {
    global DelveWebhookScreenshotEnabled
    url := Trim(url)
    DelveWebhookScreenshotEnabled := screenshotEnabled
    if FileExist(DelveWebhookScreenshotFile)
        FileDelete(DelveWebhookScreenshotFile)
    FileAppend(screenshotEnabled ? "1" : "0", DelveWebhookScreenshotFile)
    if (url = "") {
        if FileExist(DelveWebhookURLFile)
            FileDelete(DelveWebhookURLFile)
        ProcessLog("Webhook URL cleared")
        return
    }
    if !RegExMatch(url, "^https://discord(app)?\.com/api/webhooks/[0-9]+/[A-Za-z0-9_-]+$")
        MsgBox("Enter a valid Discord webhook URL.", "Webhook", "Ok Iconx")
    else {
        if FileExist(DelveWebhookURLFile)
            FileDelete(DelveWebhookURLFile)
        FileAppend(url, DelveWebhookURLFile)
        ProcessLog("Webhook URL saved")
    }
}

DelveWebhookPayload(runLength) {
    islandName := FukkiGetState("DelveIsland", "")
    runText := DelveFormatDuration(runLength)
    totalRuns := IsSet(DelveTotalRuns) ? DelveTotalRuns : 0
    runLogText := ""
    if IsSet(DelveRunLog) {
        for logLine in DelveRunLog
            runLogText .= "`n" logLine
    }
    content := "tetoMacro - tetoDelve"
        . "`nMap: " . islandName
        . "`nRun: " . runText
        . "`nTotal runs: " . totalRuns
        . runLogText
    if (StrLen(content) > 1900)
        content := SubStr(content, 1, 1900)
    content := StrReplace(content, "\", "\\")
    content := StrReplace(content, '"', '\"')
    content := StrReplace(content, "`r", "\r")
    content := StrReplace(content, "`n", "\n")
    return '{"content":"' content '"}'
}

DelveSendWebhookTest() {
    DelveSendWebhookPayload('{"content":"tetoMacro webhook test"}')
}

DelveSendRunWebhook(runLength) {
    if (runLength <= 0)
        return false
    return DelveSendWebhookPayload(DelveWebhookPayload(runLength))
}

DelveSendWebhookPayload(payloadText) {
    if !FileExist(DelveWebhookURLFile) {
        FukkiLog("Webhook URL not configured")
        return false
    }

    try {
        tempDir := A_Temp "\tetoDelve"
        if !DirExist(tempDir)
            DirCreate(tempDir)

        imageFile := tempDir "\run.png"
        payloadFile := tempDir "\payload.json"
        configFile := tempDir "\config.txt"
        scriptFile := tempDir "\send.ps1"
        screenshotEnabled := DelveWebhookScreenshotEnabled

        if screenshotEnabled {
            winTitle := IsInteger(rblxID) ? "ahk_id " rblxID : rblxID
            WinGetPos(&x, &y, &w, &h, winTitle)
            pBitmap := Gdip_BitmapFromScreen(x "|" y "|" w "|" h)
            if (!pBitmap)
                return false
            Gdip_SaveBitmapToFile(pBitmap, imageFile, 90)
            Gdip_DisposeImage(pBitmap)
        }

        webhookURL := Trim(FileRead(DelveWebhookURLFile, "UTF-8"))
        if (webhookURL = "")
            return false

        if FileExist(payloadFile)
            FileDelete(payloadFile)
        if FileExist(configFile)
            FileDelete(configFile)
        if FileExist(scriptFile)
            FileDelete(scriptFile)

        FileAppend(payloadText, payloadFile)
        FileAppend(webhookURL, configFile)

        if screenshotEnabled {
            psScript := (
                "param([string]`$Image,[string]`$Config,[string]`$PayloadFile)"
                "`nAdd-Type -AssemblyName System.Net.Http"
                "`ntry {"
                "`n`$url = [System.IO.File]::ReadAllText(`$Config)"
                "`n`$payload = [System.IO.File]::ReadAllText(`$PayloadFile)"
                "`n`$http = [System.Net.Http.HttpClient]::new()"
                "`n`$form = [System.Net.Http.MultipartFormDataContent]::new()"
                "`n`$payloadContent = [System.Net.Http.StringContent]::new(`$payload, [System.Text.Encoding]::UTF8, 'application/json')"
                "`n`$form.Add(`$payloadContent, 'payload_json')"
                "`n`$bytes = [System.IO.File]::ReadAllBytes(`$Image)"
                "`n`$imageContent = [System.Net.Http.ByteArrayContent]::new(`$bytes)"
                "`n`$imageContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('image/png')"
                "`n`$form.Add(`$imageContent, 'file', 'run.png')"
                "`n`$response = `$http.PostAsync(`$url, `$form).GetAwaiter().GetResult()"
                "`n`$code = [int]`$response.StatusCode"
                "`nif (`$code -ge 200 -and `$code -lt 300) { exit 0 } else { exit 1 }"
                "`n} catch {"
                "`nWrite-Output `$_.Exception.Message"
                "`nexit 1"
                "`n}"
            )
        } else {
            psScript := (
                "param([string]`$Config,[string]`$PayloadFile)"
                "`nAdd-Type -AssemblyName System.Net.Http"
                "`ntry {"
                "`n`$url = [System.IO.File]::ReadAllText(`$Config)"
                "`n`$payload = [System.IO.File]::ReadAllText(`$PayloadFile)"
                "`n`$http = [System.Net.Http.HttpClient]::new()"
                "`n`$content = [System.Net.Http.StringContent]::new(`$payload, [System.Text.Encoding]::UTF8, 'application/json')"
                "`n`$response = `$http.PostAsync(`$url, `$content).GetAwaiter().GetResult()"
                "`n`$code = [int]`$response.StatusCode"
                "`nif (`$code -ge 200 -and `$code -lt 300) { exit 0 } else { exit 1 }"
                "`n} catch {"
                "`nWrite-Output `$_.Exception.Message"
                "`nexit 1"
                "`n}"
            )
        }
        FileAppend(psScript, scriptFile)

        if screenshotEnabled {
            exitCode := RunWait('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' scriptFile
                '" -Image "' imageFile '" -Config "' configFile '" -PayloadFile "' payloadFile '"', , "Hide")
        } else {
            exitCode := RunWait('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' scriptFile
                '" -Config "' configFile '" -PayloadFile "' payloadFile '"', , "Hide")
        }

        if (exitCode != 0) {
            FukkiLog("Webhook send failed (exit code " exitCode ")")
            return false
        }
        FukkiLog("Webhook run sent")
        return true
    } catch Error as err {
        FukkiLog("Webhook send failed: " err.Message)
        return false
    }
}