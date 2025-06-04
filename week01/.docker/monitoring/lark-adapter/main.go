package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
	"time"
)

// AlertmanagerPayload struct để nhận JSON từ Alertmanager
type AlertmanagerPayload struct {
	Receiver          string            `json:"receiver"`
	Status            string            `json:"status"`
	Alerts            []Alert           `json:"alerts"`
	GroupLabels       map[string]string `json:"groupLabels"`
	CommonLabels      map[string]string `json:"commonLabels"`
	CommonAnnotations map[string]string `json:"commonAnnotations"`
	ExternalURL       string            `json:"externalURL"`
}

// Alert struct cho mỗi cảnh báo
type Alert struct {
	Status       string            `json:"status"`
	Labels       map[string]string `json:"labels"`
	Annotations  map[string]string `json:"annotations"`
	StartsAt     time.Time         `json:"startsAt"`
	EndsAt       time.Time         `json:"endsAt"`
	GeneratorURL string            `json:"generatorURL"`
	Fingerprint  string            `json:"fingerprint"`
}

// LarkMessage struct cho định dạng tin nhắn Lark
type LarkMessage struct {
	MsgType string `json:"msg_type"`
	Content struct {
		Post struct {
			ZhCn struct {
				Title   string              `json:"title"`
				Content [][]LarkContentItem `json:"content"`
			} `json:"zh_cn"`
		} `json:"post"`
	} `json:"content"`
}

// LarkContentItem struct cho mỗi phần tử trong nội dung Lark
type LarkContentItem struct {
	Tag      string `json:"tag,omitempty"`
	Text     string `json:"text,omitempty"`
	Href     string `json:"href,omitempty"`
	UserId   string `json:"user_id,omitempty"`
	UnEscape bool   `json:"un_escape,omitempty"`
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	
	larkWebhookURL := os.Getenv("LARK_WEBHOOK_URL")
	if larkWebhookURL == "" {
		log.Fatal("LARK_WEBHOOK_URL environment variable is not set")
	}

	http.HandleFunc("/lark", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "Failed to read request body", http.StatusBadRequest)
			return
		}

		var alertPayload AlertmanagerPayload
		if err := json.Unmarshal(body, &alertPayload); err != nil {
			http.Error(w, "Failed to parse JSON", http.StatusBadRequest)
			return
		}

		// Tạo tin nhắn Lark
		larkMsg := createLarkMessage(alertPayload)
		larkMsgJSON, err := json.Marshal(larkMsg)
		if err != nil {
			http.Error(w, "Failed to create Lark message", http.StatusInternalServerError)
			return
		}

		// Gửi tin nhắn đến Lark
		resp, err := http.Post(larkWebhookURL, "application/json", bytes.NewBuffer(larkMsgJSON))
		if err != nil {
			http.Error(w, fmt.Sprintf("Failed to send to Lark: %v", err), http.StatusInternalServerError)
			return
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			respBody, _ := ioutil.ReadAll(resp.Body)
			http.Error(w, fmt.Sprintf("Lark responded with non-OK status: %d, body: %s", resp.StatusCode, string(respBody)), http.StatusInternalServerError)
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write([]byte("Alert sent to Lark successfully"))
	})

	log.Printf("Starting server on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

func createLarkMessage(payload AlertmanagerPayload) LarkMessage {
	var larkMsg LarkMessage
	larkMsg.MsgType = "post"
	
	status := payload.Status
	statusEmoji := "⚠️"
	if status == "resolved" {
		statusEmoji = "✅"
	}
	
	// Tiêu đề tin nhắn
	title := fmt.Sprintf("%s [%s] Alert Notification", statusEmoji, strings.ToUpper(status))
	if len(payload.Alerts) == 1 {
		if alertname, ok := payload.Alerts[0].Labels["alertname"]; ok {
			title = fmt.Sprintf("%s [%s] %s", statusEmoji, strings.ToUpper(status), alertname)
		}
	}
	
	larkMsg.Content.Post.ZhCn.Title = title
	
	// Nội dung tin nhắn
	var content [][]LarkContentItem
	
	// Thêm thông tin cảnh báo
	for _, alert := range payload.Alerts {
		// Header
		var headerItems []LarkContentItem
		alertName := ""
		if name, ok := alert.Labels["alertname"]; ok {
			alertName = name
		}
		headerItems = append(headerItems, LarkContentItem{Tag: "text", Text: fmt.Sprintf("\n🚨 Alert: %s\n", alertName)})
		content = append(content, headerItems)
		
		// Severity
		var severityItems []LarkContentItem
		severity := "normal"
		if sev, ok := alert.Labels["severity"]; ok {
			severity = sev
		}
		severityText := "Normal"
		if severity == "critical" {
			severityText = "🔴 Critical"
		} else if severity == "warning" {
			severityText = "🟠 Warning"
		} else if severity == "info" {
			severityText = "🟢 Info"
		}
		severityItems = append(severityItems, LarkContentItem{Tag: "text", Text: fmt.Sprintf("Severity: %s\n", severityText)})
		content = append(content, severityItems)
		
		// Summary
		if summary, ok := alert.Annotations["summary"]; ok {
			var summaryItems []LarkContentItem
			summaryItems = append(summaryItems, LarkContentItem{Tag: "text", Text: fmt.Sprintf("Summary: %s\n", summary)})
			content = append(content, summaryItems)
		}
		
		// Description
		if description, ok := alert.Annotations["description"]; ok {
			var descItems []LarkContentItem
			descItems = append(descItems, LarkContentItem{Tag: "text", Text: fmt.Sprintf("Description: %s\n", description)})
			content = append(content, descItems)
		}
		
		// Start Time
		var timeItems []LarkContentItem
		startTime := alert.StartsAt.Format("2006-01-02 15:04:05")
		timeItems = append(timeItems, LarkContentItem{Tag: "text", Text: fmt.Sprintf("Started: %s\n", startTime)})
		content = append(content, timeItems)
		
		// End Time for resolved alerts
		if alert.Status == "resolved" {
			var endTimeItems []LarkContentItem
			endTime := alert.EndsAt.Format("2006-01-02 15:04:05")
			endTimeItems = append(endTimeItems, LarkContentItem{Tag: "text", Text: fmt.Sprintf("Resolved: %s\n", endTime)})
			content = append(content, endTimeItems)
		}
		
		// Add link to Alertmanager
		if payload.ExternalURL != "" {
			var linkItems []LarkContentItem
			linkItems = append(linkItems, LarkContentItem{Tag: "a", Text: "View in Alertmanager", Href: payload.ExternalURL})
			content = append(content, linkItems)
		}
		
		// Thêm dòng phân cách
		var separatorItems []LarkContentItem
		separatorItems = append(separatorItems, LarkContentItem{Tag: "text", Text: "\n-------------------\n"})
		content = append(content, separatorItems)
	}
	
	larkMsg.Content.Post.ZhCn.Content = content
	return larkMsg
}