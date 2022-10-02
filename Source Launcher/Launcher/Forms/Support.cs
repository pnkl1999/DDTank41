using System;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using Launcher.Properties;
using Launcher.Statics;
using Launcher.UserControls;
using Launcher.UserControls.Support;
using Properties;

namespace Launcher.Forms
{
	public class Support : Form
	{
		private IContainer icontainer_0;

		private Panel panelSupportTop;

		private Panel panelSlide;

		private Label lbLiveChat;

		private Label lbSendTicket;

		private Panel panelContent;

		private Label lbFollowTicket;

		internal static Support cQZ4JFcbkiy7wPsm9Vg;

		public Support()
		{
			InitializeComponent();
		}

		public void OpenUserControlOnPanel<UForm>() where UForm : UserControl, new()
		{
			UserControl userControl = panelContent.Controls.OfType<UForm>().FirstOrDefault();
			if (userControl == null)
			{
				userControl = new UForm
				{
					Dock = DockStyle.Fill
				};
				panelContent.Controls.Add(userControl);
				panelContent.Tag = userControl;
				userControl.Show();
				userControl.BringToFront();
				userControl.Focus();
			}
			else
			{
				userControl.BringToFront();
				userControl.Focus();
			}
		}

		private void RequestLive()
		{
			try
			{
				string text = "000000000000";
				string text2 = "0.0.0.0";
				string text3 = "launcher";
				string arg = Convert.ToBase64String(ControlMgr.CryptData(text + "|" + text2 + "|" + text3));
				Uri uri = new Uri(DDTStaticFunc.Host + string.Format(Resources.LiveChatUrl, LoginMgr.Username, arg));
				uri = new Uri("https://www.google.com/");
				WebView.Instance.wbView.Url = uri;
				DDTStaticFunc.AddUpdateLogs("RequestLive", uri.AbsoluteUri ?? "");
			}
			catch
			{
			}
		}

		private void Support_Load(object sender, EventArgs e)
		{
			OpenUserControlOnPanel<LiveChat>();
			lbLiveChat.ForeColor = Color.FromArgb(105, 224, 255);
		}

		private void lbFollowTicket_Click(object sender, EventArgs e)
		{
			if (sender is Label)
			{
				(sender as Label).ForeColor = Color.FromArgb(105, 224, 255);
				panelSlide.Left = (sender as Label).Left;
				panelSlide.Width = (sender as Label).Width;
				switch ((sender as Label).Name)
				{
				case "lbFollowTicket":
					OpenUserControlOnPanel<FollowTicket>();
					break;
				case "lbSendTicket":
					OpenUserControlOnPanel<SendTicket>();
					break;
				case "lbLiveChat":
					OpenUserControlOnPanel<LiveChat>();
					break;
				}
			}
			foreach (object control in panelSupportTop.Controls)
			{
				if (control is Label && (control as Label).Left != panelSlide.Left)
				{
					(control as Label).ForeColor = Color.White;
				}
			}
		}

		private void lbFollowTicket_MouseHover(object sender, EventArgs e)
		{
			if (sender is Label)
			{
				(sender as Label).ForeColor = Color.FromArgb(105, 224, 255);
			}
		}

		private void lbFollowTicket_MouseLeave(object sender, EventArgs e)
		{
			if (sender is Label && (sender as Label).Left != panelSlide.Left)
			{
				(sender as Label).ForeColor = Color.White;
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
			panelSupportTop = new System.Windows.Forms.Panel();
			lbSendTicket = new System.Windows.Forms.Label();
			lbLiveChat = new System.Windows.Forms.Label();
			panelSlide = new System.Windows.Forms.Panel();
			panelContent = new System.Windows.Forms.Panel();
			lbFollowTicket = new System.Windows.Forms.Label();
			panelSupportTop.SuspendLayout();
			SuspendLayout();
			panelSupportTop.BackColor = System.Drawing.Color.FromArgb(76, 71, 54);
			panelSupportTop.Controls.Add(lbFollowTicket);
			panelSupportTop.Controls.Add(lbSendTicket);
			panelSupportTop.Controls.Add(lbLiveChat);
			panelSupportTop.Controls.Add(panelSlide);
			panelSupportTop.Dock = System.Windows.Forms.DockStyle.Top;
			panelSupportTop.Location = new System.Drawing.Point(0, 0);
			panelSupportTop.Name = "panelSupportTop";
			panelSupportTop.Size = new System.Drawing.Size(1000, 40);
			panelSupportTop.TabIndex = 0;
			lbSendTicket.AutoSize = true;
			lbSendTicket.BackColor = System.Drawing.Color.Transparent;
			lbSendTicket.Cursor = System.Windows.Forms.Cursors.Hand;
			lbSendTicket.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbSendTicket.ForeColor = System.Drawing.Color.White;
			lbSendTicket.Location = new System.Drawing.Point(118, 10);
			lbSendTicket.Name = "lbSendTicket";
			lbSendTicket.Size = new System.Drawing.Size(130, 16);
			lbSendTicket.TabIndex = 3;
			lbSendTicket.Text = "GỬI PHIẾU HỖ TRỢ";
			lbSendTicket.Click += new System.EventHandler(lbFollowTicket_Click);
			lbSendTicket.MouseLeave += new System.EventHandler(lbFollowTicket_MouseLeave);
			lbSendTicket.MouseHover += new System.EventHandler(lbFollowTicket_MouseHover);
			lbLiveChat.AutoSize = true;
			lbLiveChat.BackColor = System.Drawing.Color.Transparent;
			lbLiveChat.Cursor = System.Windows.Forms.Cursors.Hand;
			lbLiveChat.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbLiveChat.ForeColor = System.Drawing.Color.White;
			lbLiveChat.Location = new System.Drawing.Point(25, 10);
			lbLiveChat.Name = "lbLiveChat";
			lbLiveChat.Size = new System.Drawing.Size(76, 16);
			lbLiveChat.TabIndex = 3;
			lbLiveChat.Text = "LIVE CHAT";
			lbLiveChat.Click += new System.EventHandler(lbFollowTicket_Click);
			lbLiveChat.MouseLeave += new System.EventHandler(lbFollowTicket_MouseLeave);
			lbLiveChat.MouseHover += new System.EventHandler(lbFollowTicket_MouseHover);
			panelSlide.BackColor = System.Drawing.Color.FromArgb(105, 224, 255);
			panelSlide.Location = new System.Drawing.Point(25, 35);
			panelSlide.Name = "panelSlide";
			panelSlide.Size = new System.Drawing.Size(63, 5);
			panelSlide.TabIndex = 2;
			panelContent.Dock = System.Windows.Forms.DockStyle.Fill;
			panelContent.Location = new System.Drawing.Point(0, 40);
			panelContent.Name = "panelContent";
			panelContent.Size = new System.Drawing.Size(1000, 595);
			panelContent.TabIndex = 1;
			lbFollowTicket.AutoSize = true;
			lbFollowTicket.BackColor = System.Drawing.Color.Transparent;
			lbFollowTicket.Cursor = System.Windows.Forms.Cursors.Hand;
			lbFollowTicket.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbFollowTicket.ForeColor = System.Drawing.Color.White;
			lbFollowTicket.Location = new System.Drawing.Point(275, 10);
			lbFollowTicket.Name = "lbFollowTicket";
			lbFollowTicket.Size = new System.Drawing.Size(116, 16);
			lbFollowTicket.TabIndex = 3;
			lbFollowTicket.Text = "THEO DÕI PHIẾU";
			lbFollowTicket.Click += new System.EventHandler(lbFollowTicket_Click);
			lbFollowTicket.MouseLeave += new System.EventHandler(lbFollowTicket_MouseLeave);
			lbFollowTicket.MouseHover += new System.EventHandler(lbFollowTicket_MouseHover);
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			BackColor = System.Drawing.Color.White;
			base.ClientSize = new System.Drawing.Size(1000, 635);
			base.Controls.Add(panelContent);
			base.Controls.Add(panelSupportTop);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Name = "Support";
			Text = "Support";
			base.Load += new System.EventHandler(Support_Load);
			panelSupportTop.ResumeLayout(false);
			panelSupportTop.PerformLayout();
			ResumeLayout(false);
		}

		internal static void nWyFxZcJQYsIFG8Vfi8()
		{
		}

		internal static void R3x6mKcYUr6JuWNsFva()
		{
		}

		internal static bool iGsbAIc5f3lYSatJCOC()
		{
			return cQZ4JFcbkiy7wPsm9Vg == null;
		}

		internal static void NRd6KQlVRBsgnvdMMP1()
		{
		}
	}
}
