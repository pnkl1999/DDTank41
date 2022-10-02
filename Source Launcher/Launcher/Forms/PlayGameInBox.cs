using System;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Runtime.CompilerServices;
using System.Windows.Forms;
using System.Xml;
using c__lib;
using Launcher.Properties;
using Launcher.Statics;
using Properties;

namespace Launcher.Forms
{
	public class PlayGameInBox : Form
	{
		[CompilerGenerated]
		private static PlayGameInBox playGameInBox_0;

		private c__control frm_loading;

		private IContainer icontainer_0;

		private Panel panelFinBox;

		private Panel panelHelpBar;

		internal static PlayGameInBox giLjGjRIkxhmFAOQfig;

		public static PlayGameInBox Instance => playGameInBox_0;

		[SpecialName]
		[CompilerGenerated]
		private static void smethod_0(PlayGameInBox value)
		{
			playGameInBox_0 = value;
		}

		public PlayGameInBox()
		{
			InitializeComponent();
			smethod_0(this);
		}

		private void PlayGameInBox_Load(object sender, EventArgs e)
		{
			panelFinBox.Size = new Size(Main.Instance.FixScaling(1000), Main.Instance.FixScaling(600));
			panelHelpBar.Size = new Size(Main.Instance.FixScaling(1000), Main.Instance.FixScaling(35));
			try
			{
				Stream manifestResourceStream = GetType().Assembly.GetManifestResourceStream("Launcher.EmbedAssemblies.Assemblies." + DDTStaticFunc.DefaultOcx + ".ocx");
				if (manifestResourceStream != null)
				{
					AxCode code = new AxCode(manifestResourceStream);
					frm_loading = new c__control(code)
					{
						Location = panelFinBox.Location,
						Dock = panelFinBox.Dock
					};
					base.Controls.Add(frm_loading);
					frm_loading.StandardMenu = false;
					frm_loading.Name = "frm_loading";
					frm_loading.TabIndex = 999;
					frm_loading.Location = panelFinBox.Location;
					frm_loading.Size = panelFinBox.Size;
					panelFinBox.Visible = false;
					frm_loading.Visible = true;
					frm_loading.OnIsInputKey += method_0;
					frm_loading.FlashProperty_WMode = "direct";
					frm_loading.FlashProperty_Movie = DDTStaticFunc.Url;
					frm_loading.FlashProperty_FlashVars = DDTStaticFunc.FlashVars;
					frm_loading.OnFlashCall += frm_loading_OnFlashCall;
					frm_loading.FlashMethod_Play();
					DDTStaticFunc.IsPlaying = 2;
					Main.Instance.SetTitle();
					Main.Instance.ShowHideQuality();
					DDTStaticFunc.AddUpdateLogs("F-In-Box", "Movie:" + DDTStaticFunc.Url + "?" + DDTStaticFunc.FlashVars);
				}
				else
				{
					DDTStaticFunc.AddUpdateLogs("Load OCX", "Launcher.EmbedAssemblies.Assemblies.winfl.ocx not found!");
					MessageBox.Show("Lỗi khởi tạo tài nguyên, vui lòng tắt launcher và thử lại. \nNếu thông báo này lặp lại nhiều lần vui lòng gửi hỗ trợ! (32140)");
				}
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 2 " + ex.Message, ex.ToString());
				MessageBox.Show("Lỗi khởi tạo tài nguyên, vui lòng tắt launcher và thử lại. \nNếu thông báo này lặp lại nhiều lần vui lòng gửi hỗ trợ! (32141)");
			}
			finally
			{
				Main.Instance.RemoveOcx();
			}
		}

		private void frm_loading_OnFlashCall(object object_0, string string_0)
		{
			XmlDocument xmlDocument = new XmlDocument();
			xmlDocument.LoadXml(string_0);
			string innerText = xmlDocument.FirstChild.Attributes.Item(0).InnerText;
			XmlNodeList elementsByTagName = xmlDocument.GetElementsByTagName("arguments");
			switch (innerText)
			{
			case "analyzeStr":
				frm_loading.FlashMethod_CallFunction("<invoke name=\"isSafeFlash\" returntype=\"xml\"><arguments><string>" + Resources.ConfigDecryptKey + "</string></arguments></invoke>");
				break;
			default:
				if (DDTStaticFunc.IsDebug)
				{
					DDTStaticFunc.AddUpdateLogs("Swf_FlashCall", innerText + " " + elementsByTagName[0].InnerText);
				}
				break;
			case "console.log":
				if (DDTStaticFunc.IsDebug)
				{
					DDTStaticFunc.AddUpdateLogs("Console", elementsByTagName[0].InnerText ?? "");
				}
				break;
			case "setDailyTask":
				break;
			case "setDailyActivity":
				break;
			case "alterBackgroundImg":
				break;
			}
		}

		public void SetQuality(int value)
		{
			if (frm_loading != null)
			{
				switch (value)
				{
				default:
					frm_loading.FlashProperty_Quality2 = "high";
					break;
				case 2:
					frm_loading.FlashProperty_Quality2 = "medium";
					break;
				case 1:
					frm_loading.FlashProperty_Quality2 = "low";
					break;
				}
				frm_loading.Refresh();
			}
		}

		private void method_0(object object_0, Keys keys_0, ref bool bool_0)
		{
			if ((uint)(keys_0 - 37) <= 3u)
			{
				bool_0 = true;
			}
			else
			{
				bool_0 = true;
			}
		}

		private void PlayGameInBox_FormClosing(object sender, FormClosingEventArgs e)
		{
			if (frm_loading != null)
			{
				frm_loading.FlashMethod_Stop();
				frm_loading.Dispose();
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(PlayGameInBox));
            this.panelFinBox = new System.Windows.Forms.Panel();
            this.panelHelpBar = new System.Windows.Forms.Panel();
            this.SuspendLayout();
            // 
            // panelFinBox
            // 
            this.panelFinBox.BackColor = System.Drawing.Color.LightSteelBlue;
            this.panelFinBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelFinBox.Location = new System.Drawing.Point(0, 0);
            this.panelFinBox.Name = "panelFinBox";
            this.panelFinBox.Size = new System.Drawing.Size(1000, 600);
            this.panelFinBox.TabIndex = 0;
            // 
            // panelHelpBar
            // 
            this.panelHelpBar.BackgroundImage = global::Properties.Resources.help_bar_2;
            this.panelHelpBar.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.panelHelpBar.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panelHelpBar.Location = new System.Drawing.Point(0, 600);
            this.panelHelpBar.Name = "panelHelpBar";
            this.panelHelpBar.Size = new System.Drawing.Size(1000, 35);
            this.panelHelpBar.TabIndex = 1;
            // 
            // PlayGameInBox
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1000, 635);
            this.Controls.Add(this.panelHelpBar);
            this.Controls.Add(this.panelFinBox);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "PlayGameInBox";
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "PlayGameInBox";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.PlayGameInBox_FormClosing);
            this.Load += new System.EventHandler(this.PlayGameInBox_Load);
            this.ResumeLayout(false);

		}

		internal static void voCjJ6RUxUvMsDDmgyj()
		{
		}

		internal static bool ibn3EARG1jRABMP2hb6()
		{
			return giLjGjRIkxhmFAOQfig == null;
		}

		internal static void qgcqA1Q0R1cNAtADXtf()
		{
		}
	}
}
