using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Net;
using System.Reflection;
using System.Windows.Forms;
using Launcher.Properties;
using Launcher.Statics;
using Properties;

namespace Launcher.Popup
{
	public class UpdateNoitice : Form
	{
		private WebClient webClient_0;

		private WebClient webClient_1;

		private string string_0 = Assembly.GetExecutingAssembly().GetName().Version.ToString();

		private string string_1 = Assembly.GetExecutingAssembly().Location;

		private string string_2 = "Gun321.Client.exe";

		private string string_3 = Path.GetTempPath() + Util.MD5(Resources.AppCLSIDKey) + "\\";

		private string string_4 = "Patch.Launcher.exe";

		private int int_0 = 5;

		private IContainer icontainer_0;

		private Panel panelLogo;

		private Panel panelContent;

		private ProgressBar progressBarDownload;

		private Label lbProcessStatus;

		private Label lbNewVersion;

		private Label lbCurrentVersion;

		private Label lbTitle;

		private Timer timer_0;

		private Timer timer_1;

		private Timer timer_2;

		private static UpdateNoitice NYKnqIyAOQIIIRV1fkE;

		public UpdateNoitice()
		{
			InitializeComponent();
			method_0();
			method_1();
		}

		private void method_0()
		{
			webClient_0 = new WebClient();
			webClient_0.DownloadProgressChanged += webClient_0_DownloadProgressChanged;
			webClient_0.DownloadFileCompleted += webClient_0_DownloadFileCompleted;
		}

		private void webClient_0_DownloadFileCompleted(object sender, AsyncCompletedEventArgs e)
		{
			timer_1.Start();
		}

		private void webClient_0_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
		{
			double num = double.Parse(e.BytesReceived.ToString());
			double num2 = double.Parse(e.TotalBytesToReceive.ToString());
			double d = num / num2 * 100.0;
			lbProcessStatus.Text = "Bắt đầu tải xuống: 1/2. Đang tải [" + num + "/" + num2 + "]";
			progressBarDownload.Value = int.Parse(Math.Truncate(d).ToString());
		}

		private void method_1()
		{
			webClient_1 = new WebClient();
			webClient_1.DownloadProgressChanged += webClient_1_DownloadProgressChanged;
			webClient_1.DownloadFileCompleted += webClient_1_DownloadFileCompleted;
		}

		private void webClient_1_DownloadFileCompleted(object sender, AsyncCompletedEventArgs e)
		{
			lbProcessStatus.Text = "Hoàn thành: 2/2. Bắt đầu khởi động lại trong 5s";
			timer_2.Start();
		}

		private void webClient_1_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
		{
			double num = double.Parse(e.BytesReceived.ToString());
			double num2 = double.Parse(e.TotalBytesToReceive.ToString());
			double d = num / num2 * 100.0;
			lbProcessStatus.Text = "Bắt đầu tải xuống: 2/2. Đang tải [" + num + "/" + num2 + "]";
			progressBarDownload.Value = int.Parse(Math.Truncate(d).ToString());
		}

		private void UpdateNoitice_Load(object sender, EventArgs e)
		{
			if (!Directory.Exists(string_3))
			{
				Directory.CreateDirectory(string_3);
			}
			lbCurrentVersion.Text += string_0;
			lbNewVersion.Text += ServerConfig.Version;
			timer_0.Start();
		}

		private void timer_0_Tick(object sender, EventArgs e)
		{
			timer_0.Stop();
			lbProcessStatus.Text = "Bắt đầu tải xuống: 1/2";
			progressBarDownload.Value = 0;
			try
			{
				Uri uri = new Uri(ServerConfig.PathClient);
				string text = string_3 + Path.GetFileName(uri.LocalPath);
				DDTStaticFunc.AddUpdateLogs("Start DownPath", "Link:" + ServerConfig.ClientGun321 + ", Save to:" + text);
				webClient_0.DownloadFileAsync(uri, text);
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 6 " + ex.Message, "PathClient:" + ServerConfig.PathClient + ", error:" + ex.ToString());
				Application.Exit();
			}
		}

		private void timer_1_Tick(object sender, EventArgs e)
		{
			timer_1.Stop();
			lbProcessStatus.Text = "Bắt đầu tải xuống: 2/2";
			progressBarDownload.Value = 0;
			try
			{
				Uri uri = new Uri(ServerConfig.ClientGun321);
				string_2 = string_3 + Path.GetFileName(uri.LocalPath);
				DDTStaticFunc.AddUpdateLogs("Start DownNewLauncher", "Link:" + ServerConfig.ClientGun321 + ", Save to:" + string_2);
				webClient_1.DownloadFileAsync(uri, string_2);
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 7 " + ex.Message, "ClientGun321:" + ServerConfig.ClientGun321 + ", error:" + ex.ToString());
				Application.Exit();
			}
		}

		private void timer_2_Tick(object sender, EventArgs e)
		{
			int_0--;
			lbProcessStatus.Text = $"Hoàn thành: 2/2. Bắt đầu khởi động lại trong {int_0}s";
			if (int_0 >= 1)
			{
				return;
			}
			timer_2.Stop();
			string text = string_3 + string_4;
			if (File.Exists(text))
			{
				string text2 = string_2 + "|" + string_1 + "|" + ServerConfig.Version;
				ProcessStartInfo startInfo = new ProcessStartInfo
				{
					FileName = text,
					Arguments = Util.Base64Encode(text2)
				};
				DDTStaticFunc.AddUpdateLogs("Run path Launcher ", "newPath:" + text + ", _arg:" + text2);
				try
				{
					Process.Start(startInfo);
				}
				catch
				{
					MessageBox.Show("Vui lòng chạy lại Launcher dưới Administrator mà thử lại!");
				}
				Application.Exit();
			}
			else
			{
				Application.Exit();
			}
		}

		protected override void Dispose(bool disposing)
		{
			if (disposing && icontainer_0 != null)
			{
				icontainer_0.Dispose();
			}
			base.Dispose(disposing);
		}

		private void InitializeComponent()
		{
			icontainer_0 = new System.ComponentModel.Container();
			panelLogo = new System.Windows.Forms.Panel();
			panelContent = new System.Windows.Forms.Panel();
			lbTitle = new System.Windows.Forms.Label();
			lbCurrentVersion = new System.Windows.Forms.Label();
			lbNewVersion = new System.Windows.Forms.Label();
			lbProcessStatus = new System.Windows.Forms.Label();
			progressBarDownload = new System.Windows.Forms.ProgressBar();
			timer_0 = new System.Windows.Forms.Timer(icontainer_0);
			timer_1 = new System.Windows.Forms.Timer(icontainer_0);
			timer_2 = new System.Windows.Forms.Timer(icontainer_0);
			panelContent.SuspendLayout();
			SuspendLayout();
			panelLogo.BackColor = System.Drawing.Color.DarkGreen;
			panelLogo.BackgroundImage = Resources.logoGunny;
			panelLogo.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			panelLogo.Dock = System.Windows.Forms.DockStyle.Left;
			panelLogo.Location = new System.Drawing.Point(0, 0);
			panelLogo.Name = "panelLogo";
			panelLogo.Size = new System.Drawing.Size(200, 125);
			panelLogo.TabIndex = 0;
			panelContent.Controls.Add(progressBarDownload);
			panelContent.Controls.Add(lbProcessStatus);
			panelContent.Controls.Add(lbNewVersion);
			panelContent.Controls.Add(lbCurrentVersion);
			panelContent.Controls.Add(lbTitle);
			panelContent.Dock = System.Windows.Forms.DockStyle.Fill;
			panelContent.Location = new System.Drawing.Point(200, 0);
			panelContent.Name = "panelContent";
			panelContent.Size = new System.Drawing.Size(270, 125);
			panelContent.TabIndex = 1;
			lbTitle.AutoSize = true;
			lbTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbTitle.ForeColor = System.Drawing.Color.Azure;
			lbTitle.Location = new System.Drawing.Point(48, 9);
			lbTitle.Name = "lbTitle";
			lbTitle.Size = new System.Drawing.Size(165, 20);
			lbTitle.TabIndex = 0;
			lbTitle.Text = "PHÁT HIỆN BẢN MỚI";
			lbCurrentVersion.AutoSize = true;
			lbCurrentVersion.ForeColor = System.Drawing.Color.Maroon;
			lbCurrentVersion.Location = new System.Drawing.Point(2, 36);
			lbCurrentVersion.Name = "lbCurrentVersion";
			lbCurrentVersion.Size = new System.Drawing.Size(104, 13);
			lbCurrentVersion.TabIndex = 1;
			lbCurrentVersion.Text = "Phiên bản hiện tại:   ";
			lbNewVersion.AutoSize = true;
			lbNewVersion.ForeColor = System.Drawing.Color.Lime;
			lbNewVersion.Location = new System.Drawing.Point(2, 58);
			lbNewVersion.Name = "lbNewVersion";
			lbNewVersion.Size = new System.Drawing.Size(103, 13);
			lbNewVersion.TabIndex = 1;
			lbNewVersion.Text = "Phiên bản hiện mới: ";
			lbProcessStatus.AutoSize = true;
			lbProcessStatus.ForeColor = System.Drawing.Color.Silver;
			lbProcessStatus.Location = new System.Drawing.Point(2, 95);
			lbProcessStatus.Name = "lbProcessStatus";
			lbProcessStatus.Size = new System.Drawing.Size(114, 13);
			lbProcessStatus.TabIndex = 2;
			lbProcessStatus.Text = "Bắt đầu tải xuống: 0/2";
			progressBarDownload.Location = new System.Drawing.Point(5, 109);
			progressBarDownload.Name = "progressBarDownload";
			progressBarDownload.Size = new System.Drawing.Size(260, 10);
			progressBarDownload.TabIndex = 3;
			timer_0.Tick += new System.EventHandler(timer_0_Tick);
			timer_1.Tick += new System.EventHandler(timer_1_Tick);
			timer_2.Interval = 1000;
			timer_2.Tick += new System.EventHandler(timer_2_Tick);
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			BackColor = System.Drawing.Color.ForestGreen;
			base.ClientSize = new System.Drawing.Size(470, 125);
			base.Controls.Add(panelContent);
			base.Controls.Add(panelLogo);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Name = "UpdateNoitice";
			base.Opacity = 0.95;
			base.ShowInTaskbar = false;
			base.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			Text = "UpdateNoitice";
			base.Load += new System.EventHandler(UpdateNoitice_Load);
			panelContent.ResumeLayout(false);
			panelContent.PerformLayout();
			ResumeLayout(false);
		}

		internal static void N5GN3dyu7TMxVch5gZZ()
		{
		}

		internal static void sY9HNRyNVhTngpW0can()
		{
		}

		internal static bool haINZxyolj2x8AeaOsq()
		{
			return NYKnqIyAOQIIIRV1fkE == null;
		}
	}
}
