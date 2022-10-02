using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Launcher.Statics;

namespace Launcher.Forms
{
	public class DailyLogs : Form
	{
		private IContainer icontainer_0;

		private WebBrowser webBrowser1;

		private static DailyLogs dAVsmpWKHPgRwr3NAro;

		public DailyLogs()
		{
			InitializeComponent();
		}

		private void DailyLogs_Load(object sender, EventArgs e)
		{
			webBrowser1.AllowWebBrowserDrop = false;
			webBrowser1.IsWebBrowserContextMenuEnabled = false;
			webBrowser1.WebBrowserShortcutsEnabled = false;
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
			webBrowser1.DocumentText = stringBuilder.ToString();
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
			webBrowser1 = new System.Windows.Forms.WebBrowser();
			SuspendLayout();
			webBrowser1.Dock = System.Windows.Forms.DockStyle.Fill;
			webBrowser1.Location = new System.Drawing.Point(0, 0);
			webBrowser1.MinimumSize = new System.Drawing.Size(20, 20);
			webBrowser1.Name = "webBrowser1";
			webBrowser1.Size = new System.Drawing.Size(1000, 635);
			webBrowser1.TabIndex = 0;
			base.AutoScaleDimensions = new System.Drawing.SizeF(8f, 16f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			base.ClientSize = new System.Drawing.Size(1000, 635);
			base.Controls.Add(webBrowser1);
			Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Margin = new System.Windows.Forms.Padding(4);
			base.Name = "DailyLogs";
			Text = "DailyLogs";
			base.Load += new System.EventHandler(DailyLogs_Load);
			ResumeLayout(false);
		}

		internal static bool GgT5LpWDAonSicY7x83()
		{
			return dAVsmpWKHPgRwr3NAro == null;
		}

		internal static void i7RqjOX9JMtNewZWLKE()
		{
		}
	}
}
