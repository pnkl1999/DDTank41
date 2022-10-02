using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Net.Security;
using System.Runtime.CompilerServices;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Windows.Forms;
using Launcher.Statics;

namespace Launcher.UserControls
{
	public class WebView : UserControl
	{
		[CompilerGenerated]
		private static WebView webView_0;

		private IContainer icontainer_0;

		public WebBrowser wbView;

		private static WebView x5DLE5GkjYM2iXFndbE;

		public static WebView Instance => webView_0;

		[SpecialName]
		[CompilerGenerated]
		private static void smethod_0(WebView value)
		{
			webView_0 = value;
		}

		public WebView()
		{
			InitializeComponent();
			smethod_0(this);
		}

		private void WebView_Load(object sender, EventArgs e)
		{
			ArrayList resourceString = ControlMgr.GetResourceString("Launcher.Resources.HTML.index.html");
			ArrayList resourceString2 = ControlMgr.GetResourceString("Launcher.Resources.HTML.js.bootstrap.bundle.min.js");
			ArrayList resourceString3 = ControlMgr.GetResourceString("Launcher.Resources.HTML.css.bootstrap.min.css");
			StringBuilder stringBuilder = new StringBuilder();
			string[] array = resourceString.Cast<string>().ToArray();
			foreach (string text in array)
			{
				stringBuilder.AppendLine(text);
				if (text.IndexOf("text/javascript") != -1)
				{
					string[] array2 = resourceString2.Cast<string>().ToArray();
					foreach (string value in array2)
					{
						stringBuilder.AppendLine(value);
					}
				}
				if (text.IndexOf("text/css") != -1)
				{
					string[] array2 = resourceString3.Cast<string>().ToArray();
					foreach (string value2 in array2)
					{
						stringBuilder.AppendLine(value2);
					}
				}
			}
			wbView.DocumentText = stringBuilder.ToString();
		}

		private void wbView_Navigating(object sender, WebBrowserNavigatingEventArgs e)
		{
			ServicePointManager.ServerCertificateValidationCallback = ValidateServerCertificate;
			ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls | (SecurityProtocolType)0xc00;
		}

		public static bool ValidateServerCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
		{
			return true;
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
			wbView = new System.Windows.Forms.WebBrowser();
			SuspendLayout();
			wbView.AllowNavigation = false;
			wbView.Dock = System.Windows.Forms.DockStyle.Fill;
			wbView.Location = new System.Drawing.Point(0, 0);
			wbView.MinimumSize = new System.Drawing.Size(20, 20);
			wbView.Name = "wbView";
			wbView.ScriptErrorsSuppressed = true;
			wbView.ScrollBarsEnabled = false;
			wbView.Size = new System.Drawing.Size(1000, 595);
			wbView.TabIndex = 0;
			wbView.WebBrowserShortcutsEnabled = false;
			wbView.Navigating += new System.Windows.Forms.WebBrowserNavigatingEventHandler(wbView_Navigating);
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			base.Controls.Add(wbView);
			base.Name = "WebView";
			base.Size = new System.Drawing.Size(1000, 595);
			base.Load += new System.EventHandler(WebView_Load);
			ResumeLayout(false);
		}

		internal static void K09bTlG7RthgVUdDpmq()
		{
		}

		internal static bool HqtdYXGCFUVqE83gSQa()
		{
			return x5DLE5GkjYM2iXFndbE == null;
		}

		internal static void v8BSmhGgaHDU8gVDugB()
		{
		}
	}
}
