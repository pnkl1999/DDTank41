using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Launcher.Properties;
using Properties;

namespace Launcher.Forms
{
	public class RunFlashStandAlone : Form
	{
		private IContainer icontainer_0;

		private Panel panelContener;

		private Panel panelFoster;

		internal static RunFlashStandAlone zpmZqgQrmnVL6Jf9GYn;

		public RunFlashStandAlone()
		{
			InitializeComponent();
		}

		[DllImport("user32.DLL")]
		private static extern IntPtr SetParent(IntPtr intptr_0, IntPtr intptr_1);

		private void method_0(string string_0)
		{
			try
			{
				string text = Path.GetTempPath() + "flashplayer32_0r0_344\\";
				ProcessStartInfo startInfo = new ProcessStartInfo
				{
					WindowStyle = ProcessWindowStyle.Hidden,
					FileName = text + "flashplayer.exe",
					Arguments = string_0
				};
				Environment.CurrentDirectory = text;
				Process process = Process.Start(startInfo);
				process.WaitForInputIdle();
				SetParent(process.MainWindowHandle, panelContener.Handle);
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message);
			}
		}

		public void CallFlash(string url = "https://ddt.trminhpc.com/UserInterface/Binary/Flash/4.2.0/DebugLoader_v_4_2_0_u20_08_22.swf?user=a1&key=e245dec88a1398e93f0dc1d91b65916d&config=https://ddt.trminhpc.com/Handler/Client/Proccess/1002/db47db22868d77ea02d89d865906244c/config.xml")
		{
			method_0(url);
		}

		private void RunFlashStandAlone_Load(object sender, EventArgs e)
		{
			panelContener.Size = new Size(Main.Instance.FixScaling(1000), Main.Instance.FixScaling(600));
			panelFoster.Size = new Size(Main.Instance.FixScaling(1000), Main.Instance.FixScaling(35));
			CallFlash("C:\\Users\\Republic\\Documents\\index.swf");
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
			panelContener = new System.Windows.Forms.Panel();
			panelFoster = new System.Windows.Forms.Panel();
			SuspendLayout();
			panelContener.BackColor = System.Drawing.Color.Black;
			panelContener.Dock = System.Windows.Forms.DockStyle.Top;
			panelContener.Location = new System.Drawing.Point(0, 0);
			panelContener.Name = "panelContener";
			panelContener.Size = new System.Drawing.Size(1000, 600);
			panelContener.TabIndex = 2;
			panelFoster.BackColor = System.Drawing.Color.Black;
			panelFoster.BackgroundImage = Resources.help_bar;
			panelFoster.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			panelFoster.Dock = System.Windows.Forms.DockStyle.Bottom;
			panelFoster.Location = new System.Drawing.Point(0, 600);
			panelFoster.Name = "panelFoster";
			panelFoster.Size = new System.Drawing.Size(1000, 35);
			panelFoster.TabIndex = 3;
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			base.ClientSize = new System.Drawing.Size(1000, 635);
			base.Controls.Add(panelFoster);
			base.Controls.Add(panelContener);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Name = "RunFlashStandAlone";
			Text = "RunFlashStandAlone";
			base.Load += new System.EventHandler(RunFlashStandAlone_Load);
			ResumeLayout(false);
		}

		internal static void e8rDhiQdK5DOj1p4JP8()
		{
		}

		internal static void CxWRBgQhQGw8c1sdJZu()
		{
		}

		internal static bool zYnMqtQIk2vhYdhIBIE()
		{
			return zpmZqgQrmnVL6Jf9GYn == null;
		}

		internal static void vNLsmFQMnJ7nSmqaU47()
		{
		}
	}
}
