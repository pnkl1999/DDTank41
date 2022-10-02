using System;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Media;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Windows.Forms;
using Bunifu.UI.WinForms.BunifuButton;
using Launcher.Statics;
using Microsoft.AspNet.SignalR.Client;

namespace Launcher.UserControls.Support
{
	public class LiveChat : UserControl
	{
		[CompilerGenerated]
		private static LiveChat liveChat_0;

		private HubConnection hubConnection_0;

		private IHubProxy ihubProxy_0;

		private string string_0 = "none";

		private string string_1 = "1.0.0.0";

		private string string_2 = "0.0.0.0";

		private string string_3 = "null";

		private string string_4 = "lcsk-" + LoginMgr.Username;

		private string string_5 = "";

		private IContainer icontainer_0;

		private Label label1;

		private Panel panelContent;

		private Panel panelChatInput;

		private RichTextBox richTxtChatInput;

		private Panel panelChatContext;

		private RichTextBox RichTextBoxConsole;

		private BunifuButton btnSend;

		internal static LiveChat FmJFptGi1jbalnAaVYC;

		public static LiveChat Instance => liveChat_0;

		[SpecialName]
		[CompilerGenerated]
		private static void smethod_0(LiveChat value)
		{
			liveChat_0 = value;
		}

		public LiveChat()
		{
			InitializeComponent();
			smethod_0(this);
			string_1 = Assembly.GetExecutingAssembly().GetName().Version.ToString();
			string_2 = DDTStaticFunc.GetLocalIPAddress();
			string_0 = string_2;
		}

		public void ConnectAsync()
		{
			if (hubConnection_0 != null)
			{
				return;
			}
			try
			{
				hubConnection_0 = new HubConnection(DDTStaticFunc.Host + ":443/signalr");
				hubConnection_0.Closed += method_0;
				ihubProxy_0 = hubConnection_0.CreateHubProxy("ChatHub");
				ihubProxy_0.On("addMessage", delegate(string string_6, string string_7)
				{
					Invoke((Action)delegate
					{
						method_2(string_6, string_7);
					});
				});
				hubConnection_0.Start().Wait();
				ihubProxy_0.Invoke("LogVisit", "Launcher", string_1, string_3, string_2, string_0, string_5, LoginMgr.Username);
				ihubProxy_0.On("setChat", delegate(string string_6, string string_7, bool bool_0)
				{
					Invoke((Action)delegate
					{
						method_3(string_6, string_7, bool_0);
					});
				});
				ihubProxy_0.On("onlineStatus", delegate(bool bool_0)
				{
					Invoke((Action)delegate
					{
						method_1(bool_0);
					});
				});
			}
			catch (Exception ex)
			{
				Invoke((Action)delegate
				{
					RichTextBoxConsole.AppendText("Hệ thống: Hỗ trợ viên chưa online!" + Environment.NewLine);
				});
				DDTStaticFunc.AddUpdateLogs("LiveChat_Load " + ex.Message, $"{DDTStaticFunc.Host}\nException:\n{ex}");
			}
		}

		private void LiveChat_Load(object sender, EventArgs e)
		{
			RichTextBoxConsole.Text = "";
			RichTextBoxConsole.AppendText("Hệ thống: Hỗ trợ viên chưa online!" + Environment.NewLine);
			ConnectAsync();
		}

		public void LeaveChat()
		{
			if (ihubProxy_0 != null)
			{
				ihubProxy_0.Invoke("LeaveChat", string_5);
			}
			if (hubConnection_0 != null)
			{
				hubConnection_0.Stop();
				hubConnection_0.Dispose();
			}
		}

		private void method_0()
		{
		}

		private void method_1(bool bool_0)
		{
			if (bool_0)
			{
				RichTextBoxConsole.AppendText(string.Format("Hệ thống: Nếu có bất cứ thắc mắc gì? Hãy trò truyện với hỗ trợ viên tại đây!" + Environment.NewLine));
				string_5 = "";
			}
		}

		private void method_2(string string_6, string string_7)
		{
			if (string_6 == LoginMgr.Username)
			{
				RichTextBoxConsole.SelectionColor = Color.Blue;
			}
			else
			{
				RichTextBoxConsole.SelectionColor = Color.Red;
			}
			RichTextBoxConsole.Focus();
			RichTextBoxConsole.AppendText(string.Format("{0}: {1}" + Environment.NewLine, string_6, string_7));
			richTxtChatInput.Focus();
			if (!(string_6 == LoginMgr.Username))
			{
				try
				{
					new SoundPlayer(Assembly.GetExecutingAssembly().GetManifestResourceStream("Launcher.Resources.Sounds.DoorBell-SoundBible.wav")).Play();
				}
				catch (Exception ex)
				{
					DDTStaticFunc.AddUpdateLogs("AddMessage " + ex.Message, $"Exception:\n{ex}");
				}
			}
		}

		private void method_3(string string_6, string string_7, bool bool_0)
		{
			string_5 = string_6;
			if (!bool_0)
			{
				RichTextBoxConsole.AppendText(string.Format("Hệ thống: Bạn đang trò chuyện với hỗ trợ viên {0}" + Environment.NewLine, string_7));
			}
			else
			{
				RichTextBoxConsole.AppendText(string.Format("Hệ thống: Tiếp tục trò chuyện với {0}" + Environment.NewLine, string_7));
			}
		}

		public bool HasSpecialChar(string input)
		{
			string text = "\\|#/()=»«£§€{};<>";
			int num = 0;
			while (true)
			{
				if (num < text.Length)
				{
					char value = text[num];
					if (input.Contains(value))
					{
						break;
					}
					num++;
					continue;
				}
				return false;
			}
			return true;
		}

		private void method_4()
		{
			if (string.IsNullOrEmpty(richTxtChatInput.Text) || string.IsNullOrWhiteSpace(richTxtChatInput.Text))
			{
				return;
			}
			if (!HasSpecialChar(richTxtChatInput.Text))
			{
				if (string.IsNullOrEmpty(string_5))
				{
					ihubProxy_0.Invoke("RequestChat", richTxtChatInput.Text, LoginMgr.Username);
				}
				else
				{
					ihubProxy_0.Invoke("Send", richTxtChatInput.Text, LoginMgr.Username);
				}
				richTxtChatInput.Clear();
				richTxtChatInput.Focus();
			}
			else
			{
				RichTextBoxConsole.AppendText(string.Format("Hệ thống: Nội dung không hợp lệ!" + Environment.NewLine));
				richTxtChatInput.Clear();
				richTxtChatInput.Focus();
			}
		}

		private void btnSend_Click(object sender, EventArgs e)
		{
			method_4();
		}

		private void richTxtChatInput_KeyDown(object sender, KeyEventArgs e)
		{
			if (e.KeyCode == Keys.Return)
			{
				method_4();
			}
		}

		private void richTxtChatInput_KeyUp(object sender, KeyEventArgs e)
		{
			if (e.KeyCode == Keys.Return)
			{
				richTxtChatInput.Clear();
				richTxtChatInput.Focus();
			}
		}

		private void LiveChat_Enter(object sender, EventArgs e)
		{
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Launcher.UserControls.Support.LiveChat));
			Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
			label1 = new System.Windows.Forms.Label();
			panelContent = new System.Windows.Forms.Panel();
			panelChatInput = new System.Windows.Forms.Panel();
			btnSend = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
			richTxtChatInput = new System.Windows.Forms.RichTextBox();
			panelChatContext = new System.Windows.Forms.Panel();
			RichTextBoxConsole = new System.Windows.Forms.RichTextBox();
			panelContent.SuspendLayout();
			panelChatInput.SuspendLayout();
			panelChatContext.SuspendLayout();
			SuspendLayout();
			label1.AutoSize = true;
			label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label1.Location = new System.Drawing.Point(357, 16);
			label1.Name = "label1";
			label1.Size = new System.Drawing.Size(209, 24);
			label1.TabIndex = 3;
			label1.Text = "HỖ TRỢ TRỰC TUYẾN";
			panelContent.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
			panelContent.Controls.Add(panelChatInput);
			panelContent.Controls.Add(panelChatContext);
			panelContent.Location = new System.Drawing.Point(20, 52);
			panelContent.Name = "panelContent";
			panelContent.Size = new System.Drawing.Size(961, 527);
			panelContent.TabIndex = 2;
			panelChatInput.Controls.Add(btnSend);
			panelChatInput.Controls.Add(richTxtChatInput);
			panelChatInput.Dock = System.Windows.Forms.DockStyle.Fill;
			panelChatInput.Location = new System.Drawing.Point(0, 386);
			panelChatInput.Name = "panelChatInput";
			panelChatInput.Size = new System.Drawing.Size(961, 141);
			panelChatInput.TabIndex = 1;
			btnSend.AllowToggling = false;
			btnSend.AnimationSpeed = 200;
			btnSend.AutoGenerateColors = false;
			btnSend.AutoSizeLeftIcon = true;
			btnSend.AutoSizeRightIcon = true;
			btnSend.BackColor = System.Drawing.Color.Transparent;
			btnSend.BackColor1 = System.Drawing.Color.DodgerBlue;
			btnSend.BackgroundImage = (System.Drawing.Image)resources.GetObject("btnSend.BackgroundImage");
			btnSend.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSend.ButtonText = "Send";
			btnSend.ButtonTextMarginLeft = 0;
			btnSend.ColorContrastOnClick = 45;
			btnSend.ColorContrastOnHover = 45;
			btnSend.Cursor = System.Windows.Forms.Cursors.Default;
			borderEdges.BottomLeft = true;
			borderEdges.BottomRight = true;
			borderEdges.TopLeft = true;
			borderEdges.TopRight = true;
			btnSend.CustomizableEdges = borderEdges;
			btnSend.DialogResult = System.Windows.Forms.DialogResult.None;
			btnSend.DisabledBorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			btnSend.DisabledFillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			btnSend.DisabledForecolor = System.Drawing.Color.FromArgb(168, 160, 168);
			btnSend.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
			btnSend.Font = new System.Drawing.Font("Segoe UI", 9f);
			btnSend.ForeColor = System.Drawing.Color.White;
			btnSend.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
			btnSend.IconLeftCursor = System.Windows.Forms.Cursors.Default;
			btnSend.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
			btnSend.IconMarginLeft = 11;
			btnSend.IconPadding = 10;
			btnSend.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
			btnSend.IconRightCursor = System.Windows.Forms.Cursors.Default;
			btnSend.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
			btnSend.IconSize = 25;
			btnSend.IdleBorderColor = System.Drawing.Color.DodgerBlue;
			btnSend.IdleBorderRadius = 1;
			btnSend.IdleBorderThickness = 1;
			btnSend.IdleFillColor = System.Drawing.Color.DodgerBlue;
			btnSend.IdleIconLeftImage = null;
			btnSend.IdleIconRightImage = null;
			btnSend.IndicateFocus = false;
			btnSend.Location = new System.Drawing.Point(880, 103);
			btnSend.Name = "btnSend";
			btnSend.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			btnSend.OnDisabledState.BorderRadius = 1;
			btnSend.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSend.OnDisabledState.BorderThickness = 1;
			btnSend.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			btnSend.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(168, 160, 168);
			btnSend.OnDisabledState.IconLeftImage = null;
			btnSend.OnDisabledState.IconRightImage = null;
			btnSend.onHoverState.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			btnSend.onHoverState.BorderRadius = 1;
			btnSend.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSend.onHoverState.BorderThickness = 1;
			btnSend.onHoverState.FillColor = System.Drawing.Color.FromArgb(105, 181, 255);
			btnSend.onHoverState.ForeColor = System.Drawing.Color.White;
			btnSend.onHoverState.IconLeftImage = null;
			btnSend.onHoverState.IconRightImage = null;
			btnSend.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
			btnSend.OnIdleState.BorderRadius = 1;
			btnSend.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSend.OnIdleState.BorderThickness = 1;
			btnSend.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
			btnSend.OnIdleState.ForeColor = System.Drawing.Color.White;
			btnSend.OnIdleState.IconLeftImage = null;
			btnSend.OnIdleState.IconRightImage = null;
			btnSend.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(40, 96, 144);
			btnSend.OnPressedState.BorderRadius = 1;
			btnSend.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSend.OnPressedState.BorderThickness = 1;
			btnSend.OnPressedState.FillColor = System.Drawing.Color.FromArgb(40, 96, 144);
			btnSend.OnPressedState.ForeColor = System.Drawing.Color.White;
			btnSend.OnPressedState.IconLeftImage = null;
			btnSend.OnPressedState.IconRightImage = null;
			btnSend.Size = new System.Drawing.Size(78, 25);
			btnSend.TabIndex = 1;
			btnSend.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			btnSend.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
			btnSend.TextMarginLeft = 0;
			btnSend.TextPadding = new System.Windows.Forms.Padding(0);
			btnSend.UseDefaultRadiusAndThickness = true;
			btnSend.Click += new System.EventHandler(btnSend_Click);
			richTxtChatInput.Anchor = System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
			richTxtChatInput.Location = new System.Drawing.Point(0, 12);
			richTxtChatInput.Name = "richTxtChatInput";
			richTxtChatInput.Size = new System.Drawing.Size(958, 83);
			richTxtChatInput.TabIndex = 0;
			richTxtChatInput.Text = "";
			richTxtChatInput.KeyDown += new System.Windows.Forms.KeyEventHandler(richTxtChatInput_KeyDown);
			richTxtChatInput.KeyUp += new System.Windows.Forms.KeyEventHandler(richTxtChatInput_KeyUp);
			panelChatContext.AutoScroll = true;
			panelChatContext.Controls.Add(RichTextBoxConsole);
			panelChatContext.Dock = System.Windows.Forms.DockStyle.Top;
			panelChatContext.Location = new System.Drawing.Point(0, 0);
			panelChatContext.Name = "panelChatContext";
			panelChatContext.Size = new System.Drawing.Size(961, 386);
			panelChatContext.TabIndex = 0;
			RichTextBoxConsole.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			RichTextBoxConsole.Cursor = System.Windows.Forms.Cursors.Default;
			RichTextBoxConsole.Dock = System.Windows.Forms.DockStyle.Fill;
			RichTextBoxConsole.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			RichTextBoxConsole.Location = new System.Drawing.Point(0, 0);
			RichTextBoxConsole.Name = "RichTextBoxConsole";
			RichTextBoxConsole.ReadOnly = true;
			RichTextBoxConsole.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
			RichTextBoxConsole.Size = new System.Drawing.Size(961, 386);
			RichTextBoxConsole.TabIndex = 1;
			RichTextBoxConsole.Text = "Hệ thống: Hỗ trợ viên chưa online!";
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			BackColor = System.Drawing.Color.White;
			base.Controls.Add(label1);
			base.Controls.Add(panelContent);
			base.Name = "LiveChat";
			base.Size = new System.Drawing.Size(1000, 595);
			base.Load += new System.EventHandler(LiveChat_Load);
			base.Enter += new System.EventHandler(LiveChat_Enter);
			panelContent.ResumeLayout(false);
			panelChatInput.ResumeLayout(false);
			panelChatContext.ResumeLayout(false);
			ResumeLayout(false);
			PerformLayout();
		}

		[CompilerGenerated]
		private void method_5(string string_6, string string_7)
		{
			Invoke((Action)delegate
			{
				method_2(string_6, string_7);
			});
		}

		[CompilerGenerated]
		private void method_6(string string_6, string string_7, bool bool_0)
		{
			Invoke((Action)delegate
			{
				method_3(string_6, string_7, bool_0);
			});
		}

		[CompilerGenerated]
		private void method_7(bool bool_0)
		{
			Invoke((Action)delegate
			{
				method_1(bool_0);
			});
		}

		[CompilerGenerated]
		private void method_8()
		{
			RichTextBoxConsole.AppendText("Hệ thống: Hỗ trợ viên chưa online!" + Environment.NewLine);
		}

		internal static void GTeliGGz0VfRUabWU0U()
		{
		}

		internal static void hdcpmvdqOKM82ANod5L()
		{
		}

		internal static bool dL9i9nGaf40HiBVMBRD()
		{
			return FmJFptGi1jbalnAaVYC == null;
		}

		internal static void yunbj9h3TAbmkPVDLg1()
		{
		}
	}
}
