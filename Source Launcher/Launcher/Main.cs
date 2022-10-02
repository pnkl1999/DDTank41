using System;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Launcher.Forms;
using Launcher.Popup;
using Launcher.Properties;
using Launcher.Statics;
using Launcher.Test;
using Launcher.Update;
using Microsoft.AspNet.SignalR.Client;
using Properties;

namespace Launcher
{
	public class Main : Form
	{
		public enum DeviceCap
		{
			VERTRES = 10,
			DESKTOPVERTRES = 117,
			LOGPIXELSY = 90
		}

		[CompilerGenerated]
		private static Main main_0;

		private HubConnection hubConnection_0;

		private IHubProxy ihubProxy_0;

		private decimal decimal_0 = 1m;

		private string string_0 = Assembly.GetExecutingAssembly().GetName().Version.ToString();

		private bool bool_0 = true;

		private IContainer icontainer_0;

		private Panel panelTitle;

		private Label lbTitle;

		private PictureBox picBoxClose;

		private Button btmSignOut;

		private Panel panelUserInfo;

		private PictureBox picBoxAvatar;

		private LinkLabel yZhWaTiwe;

		private Label lbVipLv;

		private Label lbUsername;

		private Button btnHome;

		private Button btnSupport;

		private Button btnPay;

		private Button btnPlayGame;

		private LinkLabel linkLbChangePass;

		private Timer timer_0;

		private Button btnChangeServer;

		private RadioButton zGqQyuhkWa;

		private RadioButton radioBtnHigh;

		private RadioButton radioBtnMedium;

		private Label lbQuality;

		private PictureBox picBoxMinimum;

		private PictureBox picBoxMenu;

		private PictureBox pictureBoxRefresh;

		private PictureBox pictureBoxCash;

		public Label lbCash;

		private BackgroundWorker backgroundWorker_0;

		public Panel panelLeftMenu;

		private Panel panelMain;

		private Timer timer_1;
        private IContainer components;
        private PictureBox btnMaxSize;
        private Button btnGroup;
        private Button btnFanpage;
        internal static Main fyCAuH2U8EHSdWX235;

		public static Main Instance => main_0;

		[SpecialName]
		[CompilerGenerated]
		private static void smethod_0(Main value)
		{
			main_0 = value;
		}

		public Main()
		{
			InitializeComponent();
			smethod_0(this);
            btnSupport.Visible = false;

        }

		private void scanCheating()
		{
			string text = new HackTools().FindHack();
			if (!string.IsNullOrEmpty(text))
			{
				timer_1.Stop();
				MessageBox.Show("Phát hiện bạn đang dùng phần mềm cấm: " + text);
				Application.Exit();
			}
		}

		[DllImport("user32.DLL")]
		private static extern void ReleaseCapture();

		[DllImport("user32.DLL")]
		private static extern void SendMessage(IntPtr intptr_0, int int_0, int int_1, int int_2);

		private void panelTitle_MouseMove(object sender, MouseEventArgs e)
		{
			ReleaseCapture();
			SendMessage(base.Handle, 274, 61458, 0);
		}

		public void ConnectAsync()
		{
			if (hubConnection_0 != null)
			{
				return;
			}
			try
			{
				//hubConnection_0 = new HubConnection(DDTStaticFunc.Host + ":443/signalr");
				//hubConnection_0.Closed += method_1;
				//ihubProxy_0 = hubConnection_0.CreateHubProxy("LiveSupportHub");
				//ihubProxy_0.On("broadcastMessage", delegate(string string_1, string string_2)
				//{
				//	Invoke((Action)delegate
				//	{
				//		dThycgdc8(string_1, string_2);
				//	});
				//});
				//hubConnection_0.Start().Wait();
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Main_Load " + ex.Message, $"{DDTStaticFunc.Host}\nException:\n{ex}");
			}
		}

		private void dThycgdc8(string string_1, string string_2)
		{
			if (string_1 == LoginMgr.Username && bool_0)
			{
				MessageBox.Show("Tài khoản [" + string_1 + "] của bạn đã bị thay đổi mật khẩu ở thiết bị khác khác.\nNếu không phải do bạn thực hiện hãy sử dụng số DT đã được đăng ký để lấy lại tài khoản.\nNếu bạn thực hiện thay đổi hãy bỏ qua thông báo này.", "Cảnh báo");
				LogOut(isKick: false);
			}
		}

		private void method_1()
		{
		}

		public void SetTitle()
		{
			Label label = lbTitle;
			label.Text = label.Text + " - " + DDTStaticFunc.ServerName;
		}

		private string method_2()
		{
			return ((AssemblyTitleAttribute)Attribute.GetCustomAttribute(Assembly.GetExecutingAssembly(), typeof(AssemblyTitleAttribute), inherit: false))?.Title;
		}

		[DllImport("gdi32.dll")]
		private static extern int GetDeviceCaps(IntPtr intptr_0, int int_0);

		private void method_3()
		{
			Graphics graphics = Graphics.FromHwnd(IntPtr.Zero);
			IntPtr hdc = graphics.GetHdc();
			int deviceCaps = GetDeviceCaps(hdc, 10);
			int deviceCaps2 = GetDeviceCaps(hdc, 117);
			int deviceCaps3 = GetDeviceCaps(hdc, 90);
			graphics.ReleaseHdc(hdc);
			decimal num = (decimal)deviceCaps3 / 96m;
			_ = (decimal)(deviceCaps2 / deviceCaps);
			if (deviceCaps3 > 96)
			{
				decimal_0 = num;
			}
		}

		private void Main_Load(object sender, EventArgs e)
		{
			method_3();
			int num = FixScaling(1200);
			int num2 = FixScaling(665);
			base.Size = new Size(num, num2);
			string text3 = (Text = (lbTitle.Text = method_2() + " " + ServerConfig.SiteName + " Phiên bản v" + string_0));
			lbUsername.Text = LoginMgr.Username;
			lbVipLv.Text = "VIP " + LoginMgr.VIPLevel;
			btnChangeServer.Visible = false;
			OpenFormOnPanel<Slider>();
			ShowHideQuality(show: false);
			pictureBoxRefresh_Click(null, null);
			ConnectAsync();
			timer_1.Start();
		}

		private void Main_Resize(object sender, EventArgs e)
		{
			btmSignOut.Location = new Point(0, FixScaling(585));
		}

		public void OpenUserControlOnPanel<UForm>() where UForm : UserControl, new()
		{
			UserControl userControl = main_0.panelMain.Controls.OfType<UForm>().FirstOrDefault();
			if (userControl == null)
			{
				userControl = new UForm
				{
					Dock = DockStyle.Fill
				};
				main_0.panelMain.Controls.Add(userControl);
				main_0.panelMain.Tag = userControl;
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

		public void OpenFormOnPanel<IForm>() where IForm : Form, new()
		{
			Form form = main_0.panelMain.Controls.OfType<IForm>().FirstOrDefault();
			if (form == null)
			{
				form = new IForm
				{
					TopLevel = false,
					FormBorderStyle = FormBorderStyle.None,
					Dock = DockStyle.Fill
				};
				main_0.panelMain.Controls.Add(form);
				main_0.panelMain.Tag = form;
				form.Show();
				form.BringToFront();
				form.FormClosed += smethod_1;
			}
			else
			{
				form.BringToFront();
			}
		}

		private static void smethod_1(object object_0, object object_1)
		{
			_ = Application.OpenForms["ServerList"];
			_ = Application.OpenForms["PlayGameOcx"];
			_ = Application.OpenForms["PlayGameInBox"];
		}

		private void picBoxClose_Click(object sender, EventArgs e)
		{
			if (MessageBox.Show("Bạn có chắc muốn thoát game không?", "Cảnh báo", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation) == DialogResult.Yes)
			{
				Application.Exit();
			}
		}

		private void CsuKlqcaj(object sender, EventArgs e)
		{
			picBoxClose.Image = Resources.icons8_shutdown_80;
		}

		private void picBoxClose_MouseLeave(object sender, EventArgs e)
		{
			picBoxClose.Image = Resources.icons8_shutdown_80;
		}

		private void btmSignOut_Click(object sender, EventArgs e)
		{
			if (MessageBox.Show("Xác nhận đăng xuất?", "Nhắc nhở", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation) == DialogResult.Yes)
			{
				LogOut(isKick: false);
			}
		}

		public void LogOut(bool isKick = true)
		{
			if (isKick)
			{
				//ihubProxy_0.Invoke("Send", LoginMgr.Username, "LogOut");
				bool_0 = false;
			}
			Close();
		}

		private void Wyawasmcu(Enum0 enum0_0)
		{
			Color backColor = Color.FromArgb(61, 34, 22);//61, 34, 22
			Color backColor2 = Color.FromArgb(81, 33, 1);
			DDTStaticFunc.ButtomStatus = (int)enum0_0;
			btnHome.BackColor = backColor2;
			btnPlayGame.BackColor = backColor2;
			btnPay.BackColor = backColor2;
			btnSupport.BackColor = backColor2;
			switch (enum0_0)
			{
			case (Enum0)0:
				btnHome.BackColor = backColor;
				break;
			case (Enum0)1:
				btnPlayGame.BackColor = backColor;
				break;
			case (Enum0)2:
				btnPay.BackColor = backColor;
				break;
			case (Enum0)3:
				btnSupport.BackColor = backColor;
				break;
			case (Enum0)4:
				break;
			}
		}

		private void efThmTvYq_Click(object sender, EventArgs e)
		{
            //Wyawasmcu((Enum0)0);
            //OpenFormOnPanel<Slider>();
            Process.Start("http://gun3m.com/");
        }

		private void btnPlayGame_Click(object sender, EventArgs e)
		{
			Wyawasmcu((Enum0)1);
			if (DDTStaticFunc.IsPlaying == 1)
			{
				btnChangeServer.Visible = true;
			}
			if (DDTStaticFunc.IsPlaying == 2)
			{
				OpenFormOnPanel<PlayGameInBox>();
				btnChangeServer.Visible = true;
			}
			if (DDTStaticFunc.IsPlaying == 0)
			{
				OpenFormOnPanel<ServerList>();
				btnChangeServer.Visible = false;
			}
		}

		private void btnPay_Click(object sender, EventArgs e)
		{
			Wyawasmcu((Enum0)2);
			OpenFormOnPanel<Payment>();
		}

		private void btnSupport_Click(object sender, EventArgs e)
		{
			Wyawasmcu((Enum0)3);
			OpenFormOnPanel<Support>();
		}

		private void qSidvyqoK(object sender, EventArgs e)
		{
			if (MessageBox.Show("Bạn có chắc muốn đổi máy chủ không?", "Cảnh báo", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation) == DialogResult.Yes)
			{
				method_4();
			}
			else
			{
				panelMain.Controls.OfType<PlayGameInBox>().FirstOrDefault()?.Focus();
			}
		}

		private void method_4()
		{
			lbTitle.Text = method_2() + " " + ServerConfig.SiteName + " Phiên bản v" + string_0;
			DDTStaticFunc.IsPlaying = 0;
			btnPlayGame_Click(null, null);
			btnPlayGame.Focus();
			ShowHideQuality(show: false);
			if (panelMain != null)
			{
				PlayGameInBox playGameInBox = panelMain.Controls.OfType<PlayGameInBox>().FirstOrDefault();
				if (playGameInBox != null)
				{
					playGameInBox.Close();
					panelMain.Controls.Remove(playGameInBox);
					playGameInBox.Dispose();
				}
			}
		}

		public void ChangePlayMode()
		{
		}

		public void RemoveOcx()
		{
		}

		private void timer_0_Tick(object sender, EventArgs e)
		{
		}

		public void ShowHideQuality(bool show = true)
		{
			lbQuality.Visible = show;
			zGqQyuhkWa.Visible = show;
			radioBtnMedium.Visible = show;
			radioBtnHigh.Visible = show;
			btnChangeServer.Visible = show;
		}

		private void zGqQyuhkWa_CheckedChanged(object sender, EventArgs e)
		{
			if (Application.OpenForms["PlayGameInBox"] != null)
			{
				PlayGameInBox.Instance.SetQuality(1);
			}
		}

		private void radioBtnMedium_CheckedChanged(object sender, EventArgs e)
		{
			if (Application.OpenForms["PlayGameInBox"] != null)
			{
				PlayGameInBox.Instance.SetQuality(2);
			}
		}

		private void radioBtnHigh_CheckedChanged(object sender, EventArgs e)
		{
			if (Application.OpenForms["PlayGameInBox"] != null)
			{
				PlayGameInBox.Instance.SetQuality(3);
			}
		}

		private void picBoxMinimum_MouseHover(object sender, EventArgs e)
		{
			picBoxMinimum.Image = Resources.icons8_hidden_64;
		}

		private void picBoxMinimum_MouseLeave(object sender, EventArgs e)
		{
			picBoxMinimum.Image = Resources.icons8_hidden_64;
		}

		private void picBoxMinimum_Click(object sender, EventArgs e)
		{
			base.WindowState = FormWindowState.Minimized;
		}

		private void yZhWaTiwe_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			//MessageBox.Show("Comming soon!");
			new AccountInfo().ShowDialog();
		}

		private void linkLbChangePass_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			new ChangePassword().ShowDialog();
		}

		public int FixScaling(int value)
		{
			return (int)Math.Round((decimal)value * decimal_0);
		}

		private void method_5(bool bool_1)
		{
			int num = 1;
			if (!(panelLeftMenu.Width == FixScaling(200) && bool_1))
			{
				panelLeftMenu.Width = FixScaling(200);
				yZhWaTiwe.Visible = true;
				picBoxAvatar.Width = FixScaling(67);
				picBoxAvatar.Height = FixScaling(67);
				picBoxAvatar.Location = new Point(FixScaling(7), FixScaling(7));
				picBoxMenu.Location = new Point(FixScaling(175), FixScaling(3));
				panelMain.Location = new Point(FixScaling(200), FixScaling(30));
				base.Width = FixScaling(1200);
				num = FixScaling(8);
				lbQuality.Location = new Point(FixScaling(860), FixScaling(9));
				zGqQyuhkWa.Location = new Point(FixScaling(930), num);
				radioBtnMedium.Location = new Point(FixScaling(986), num);
				radioBtnHigh.Location = new Point(FixScaling(1055), num);
				picBoxMinimum.Location = new Point(FixScaling(1100), num);
				picBoxClose.Location = new Point(FixScaling(1169), num);
			}
			else
			{
				panelLeftMenu.Width = FixScaling(40);
				yZhWaTiwe.Visible = false;
				picBoxAvatar.Width = FixScaling(38);
				picBoxAvatar.Height = FixScaling(38);
				picBoxAvatar.Location = new Point(FixScaling(1), FixScaling(40));
				picBoxMenu.Location = new Point(FixScaling(9), FixScaling(3));
				panelMain.Location = new Point(FixScaling(40), FixScaling(30));
				base.Width = FixScaling(1040);
				num = FixScaling(8);
				lbQuality.Location = new Point(FixScaling(700), FixScaling(9));
				zGqQyuhkWa.Location = new Point(FixScaling(770), num);
				radioBtnMedium.Location = new Point(FixScaling(826), num);
				radioBtnHigh.Location = new Point(FixScaling(895), num);
				picBoxMinimum.Location = new Point(FixScaling(1260), num);
				picBoxClose.Location = new Point(FixScaling(1329), num);
			}
		}

		private void picBoxMenu_Click(object sender, EventArgs e)
		{
			method_5(bool_1: true);
		}

		private void Main_Activated(object sender, EventArgs e)
		{
			_ = Application.OpenForms["PlayGameOcx"];
			if (Application.OpenForms["PlayGameInBox"] != null)
			{
				panelMain.Controls.OfType<PlayGameInBox>().FirstOrDefault()?.Focus();
			}
		}

		private void pictureBoxRefresh_Click(object sender, EventArgs e)
		{
			Cursor = Cursors.WaitCursor;
			NameValueCollection param = new NameValueCollection
			{
				{
					"u",
					LoginMgr.Username
				},
				{
					"p",
					LoginMgr.Password
				},
				{
					"key",
					Util.MD5(LoginMgr.Username + LoginMgr.Password + Resources.PublicKey)
				}
			};
			string text = ControlMgr.Post(DDTStaticFunc.Host + Resources.CashInfo, param);
			try
			{
				if (text.IndexOf(":") != -1)
				{
					string[] array = text.Split(':');
					lbVipLv.Text = "VIP " + array[0];
					double num = double.Parse(array[1]);
					lbCash.Text = num.ToString("n", CultureInfo.GetCultureInfo("vi-VN")).Replace(",00", "");
				}
				else
				{
					DDTStaticFunc.AddUpdateLogs("Refresh Cash", DDTStaticFunc.Host + Resources.CashInfo + " result:" + text);
					lbCash.Text = "0";
				}
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 5b " + ex.Message, $"result:{text},  \nerrors:{ex}");
			}
			Cursor = Cursors.Default;
		}

		private void Main_Shown(object sender, EventArgs e)
		{
			method_4();
		}

		private void inYpCcGpy(object sender, EventArgs e)
		{
			scanCheating();
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Main));
            this.panelTitle = new System.Windows.Forms.Panel();
            this.btnMaxSize = new System.Windows.Forms.PictureBox();
            this.lbQuality = new System.Windows.Forms.Label();
            this.radioBtnHigh = new System.Windows.Forms.RadioButton();
            this.radioBtnMedium = new System.Windows.Forms.RadioButton();
            this.zGqQyuhkWa = new System.Windows.Forms.RadioButton();
            this.picBoxMinimum = new System.Windows.Forms.PictureBox();
            this.picBoxClose = new System.Windows.Forms.PictureBox();
            this.lbTitle = new System.Windows.Forms.Label();
            this.panelLeftMenu = new System.Windows.Forms.Panel();
            this.btnGroup = new System.Windows.Forms.Button();
            this.btnFanpage = new System.Windows.Forms.Button();
            this.panelUserInfo = new System.Windows.Forms.Panel();
            this.pictureBoxCash = new System.Windows.Forms.PictureBox();
            this.pictureBoxRefresh = new System.Windows.Forms.PictureBox();
            this.picBoxMenu = new System.Windows.Forms.PictureBox();
            this.lbCash = new System.Windows.Forms.Label();
            this.lbVipLv = new System.Windows.Forms.Label();
            this.lbUsername = new System.Windows.Forms.Label();
            this.linkLbChangePass = new System.Windows.Forms.LinkLabel();
            this.yZhWaTiwe = new System.Windows.Forms.LinkLabel();
            this.picBoxAvatar = new System.Windows.Forms.PictureBox();
            this.btnChangeServer = new System.Windows.Forms.Button();
            this.btnSupport = new System.Windows.Forms.Button();
            this.btnPay = new System.Windows.Forms.Button();
            this.btnPlayGame = new System.Windows.Forms.Button();
            this.btnHome = new System.Windows.Forms.Button();
            this.btmSignOut = new System.Windows.Forms.Button();
            this.panelMain = new System.Windows.Forms.Panel();
            this.timer_0 = new System.Windows.Forms.Timer(this.components);
            this.backgroundWorker_0 = new System.ComponentModel.BackgroundWorker();
            this.timer_1 = new System.Windows.Forms.Timer(this.components);
            this.panelTitle.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.btnMaxSize)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxMinimum)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxClose)).BeginInit();
            this.panelLeftMenu.SuspendLayout();
            this.panelUserInfo.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxCash)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxRefresh)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxMenu)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxAvatar)).BeginInit();
            this.SuspendLayout();
            // 
            // panelTitle
            // 
            this.panelTitle.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.panelTitle.Controls.Add(this.btnMaxSize);
            this.panelTitle.Controls.Add(this.lbQuality);
            this.panelTitle.Controls.Add(this.radioBtnHigh);
            this.panelTitle.Controls.Add(this.radioBtnMedium);
            this.panelTitle.Controls.Add(this.zGqQyuhkWa);
            this.panelTitle.Controls.Add(this.picBoxMinimum);
            this.panelTitle.Controls.Add(this.picBoxClose);
            this.panelTitle.Controls.Add(this.lbTitle);
            this.panelTitle.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelTitle.Location = new System.Drawing.Point(0, 0);
            this.panelTitle.Margin = new System.Windows.Forms.Padding(2);
            this.panelTitle.Name = "panelTitle";
            this.panelTitle.Size = new System.Drawing.Size(1200, 30);
            this.panelTitle.TabIndex = 0;
            this.panelTitle.MouseMove += new System.Windows.Forms.MouseEventHandler(this.panelTitle_MouseMove);
            // 
            // btnMaxSize
            // 
            this.btnMaxSize.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnMaxSize.Image = global::Properties.Resources.icons8_enlarge_512;
            this.btnMaxSize.Location = new System.Drawing.Point(1135, 0);
            this.btnMaxSize.Name = "btnMaxSize";
            this.btnMaxSize.Size = new System.Drawing.Size(28, 30);
            this.btnMaxSize.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.btnMaxSize.TabIndex = 4;
            this.btnMaxSize.TabStop = false;
            this.btnMaxSize.Click += new System.EventHandler(this.btnMaxSize_Click);
            // 
            // lbQuality
            // 
            this.lbQuality.AutoSize = true;
            this.lbQuality.ForeColor = System.Drawing.Color.White;
            this.lbQuality.Location = new System.Drawing.Point(766, 9);
            this.lbQuality.Name = "lbQuality";
            this.lbQuality.Size = new System.Drawing.Size(61, 13);
            this.lbQuality.TabIndex = 3;
            this.lbQuality.Text = "Chất lượng:";
            // 
            // radioBtnHigh
            // 
            this.radioBtnHigh.AutoSize = true;
            this.radioBtnHigh.Checked = true;
            this.radioBtnHigh.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.radioBtnHigh.ForeColor = System.Drawing.Color.Lavender;
            this.radioBtnHigh.Location = new System.Drawing.Point(961, 8);
            this.radioBtnHigh.Name = "radioBtnHigh";
            this.radioBtnHigh.Size = new System.Drawing.Size(43, 17);
            this.radioBtnHigh.TabIndex = 2;
            this.radioBtnHigh.TabStop = true;
            this.radioBtnHigh.Text = "Cao";
            this.radioBtnHigh.UseVisualStyleBackColor = true;
            this.radioBtnHigh.CheckedChanged += new System.EventHandler(this.radioBtnHigh_CheckedChanged);
            // 
            // radioBtnMedium
            // 
            this.radioBtnMedium.AutoSize = true;
            this.radioBtnMedium.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.radioBtnMedium.ForeColor = System.Drawing.Color.Lavender;
            this.radioBtnMedium.Location = new System.Drawing.Point(892, 8);
            this.radioBtnMedium.Name = "radioBtnMedium";
            this.radioBtnMedium.Size = new System.Drawing.Size(61, 17);
            this.radioBtnMedium.TabIndex = 2;
            this.radioBtnMedium.Text = "Thường";
            this.radioBtnMedium.UseVisualStyleBackColor = true;
            this.radioBtnMedium.CheckedChanged += new System.EventHandler(this.radioBtnMedium_CheckedChanged);
            // 
            // zGqQyuhkWa
            // 
            this.zGqQyuhkWa.AutoSize = true;
            this.zGqQyuhkWa.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.zGqQyuhkWa.ForeColor = System.Drawing.Color.Lavender;
            this.zGqQyuhkWa.Location = new System.Drawing.Point(836, 8);
            this.zGqQyuhkWa.Name = "zGqQyuhkWa";
            this.zGqQyuhkWa.Size = new System.Drawing.Size(49, 17);
            this.zGqQyuhkWa.TabIndex = 2;
            this.zGqQyuhkWa.Text = "Thấp";
            this.zGqQyuhkWa.UseVisualStyleBackColor = true;
            this.zGqQyuhkWa.CheckedChanged += new System.EventHandler(this.zGqQyuhkWa_CheckedChanged);
            // 
            // picBoxMinimum
            // 
            this.picBoxMinimum.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.picBoxMinimum.Image = global::Properties.Resources.icons8_hidden_64;
            this.picBoxMinimum.Location = new System.Drawing.Point(1100, 0);
            this.picBoxMinimum.Name = "picBoxMinimum";
            this.picBoxMinimum.Size = new System.Drawing.Size(28, 30);
            this.picBoxMinimum.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picBoxMinimum.TabIndex = 1;
            this.picBoxMinimum.TabStop = false;
            this.picBoxMinimum.Click += new System.EventHandler(this.picBoxMinimum_Click);
            this.picBoxMinimum.MouseLeave += new System.EventHandler(this.picBoxMinimum_MouseLeave);
            this.picBoxMinimum.MouseHover += new System.EventHandler(this.picBoxMinimum_MouseHover);
            // 
            // picBoxClose
            // 
            this.picBoxClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.picBoxClose.Image = global::Properties.Resources.icons8_shutdown_80;
            this.picBoxClose.Location = new System.Drawing.Point(1169, -1);
            this.picBoxClose.Name = "picBoxClose";
            this.picBoxClose.Size = new System.Drawing.Size(28, 30);
            this.picBoxClose.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picBoxClose.TabIndex = 1;
            this.picBoxClose.TabStop = false;
            this.picBoxClose.Click += new System.EventHandler(this.picBoxClose_Click);
            this.picBoxClose.MouseLeave += new System.EventHandler(this.picBoxClose_MouseLeave);
            this.picBoxClose.MouseHover += new System.EventHandler(this.CsuKlqcaj);
            // 
            // lbTitle
            // 
            this.lbTitle.AutoSize = true;
            this.lbTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbTitle.ForeColor = System.Drawing.Color.White;
            this.lbTitle.Location = new System.Drawing.Point(4, 6);
            this.lbTitle.Name = "lbTitle";
            this.lbTitle.Size = new System.Drawing.Size(116, 18);
            this.lbTitle.TabIndex = 0;
            this.lbTitle.Text = "Gunny Launcher";
            this.lbTitle.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // panelLeftMenu
            // 
            this.panelLeftMenu.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.panelLeftMenu.Controls.Add(this.btnGroup);
            this.panelLeftMenu.Controls.Add(this.btnFanpage);
            this.panelLeftMenu.Controls.Add(this.panelUserInfo);
            this.panelLeftMenu.Controls.Add(this.btnChangeServer);
            this.panelLeftMenu.Controls.Add(this.btnSupport);
            this.panelLeftMenu.Controls.Add(this.btnPay);
            this.panelLeftMenu.Controls.Add(this.btnPlayGame);
            this.panelLeftMenu.Controls.Add(this.btnHome);
            this.panelLeftMenu.Controls.Add(this.btmSignOut);
            this.panelLeftMenu.Dock = System.Windows.Forms.DockStyle.Left;
            this.panelLeftMenu.Location = new System.Drawing.Point(0, 30);
            this.panelLeftMenu.Name = "panelLeftMenu";
            this.panelLeftMenu.Size = new System.Drawing.Size(200, 635);
            this.panelLeftMenu.TabIndex = 1;
            // 
            // btnGroup
            // 
            this.btnGroup.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.btnGroup.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.btnGroup.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnGroup.FlatAppearance.BorderSize = 0;
            this.btnGroup.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnGroup.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnGroup.ForeColor = System.Drawing.Color.White;
            this.btnGroup.Image = global::Properties.Resources.cyrus_group;
            this.btnGroup.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnGroup.Location = new System.Drawing.Point(1, 396);
            this.btnGroup.Name = "btnGroup";
            this.btnGroup.Size = new System.Drawing.Size(200, 40);
            this.btnGroup.TabIndex = 3;
            this.btnGroup.Text = "Nhóm Game";
            this.btnGroup.UseVisualStyleBackColor = false;
            this.btnGroup.Click += new System.EventHandler(this.btnGroup_Click);
            // 
            // btnFanpage
            // 
            this.btnFanpage.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.btnFanpage.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.btnFanpage.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnFanpage.FlatAppearance.BorderSize = 0;
            this.btnFanpage.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnFanpage.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnFanpage.ForeColor = System.Drawing.Color.White;
            this.btnFanpage.Image = global::Properties.Resources.cyrus_facebook;
            this.btnFanpage.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnFanpage.Location = new System.Drawing.Point(1, 350);
            this.btnFanpage.Name = "btnFanpage";
            this.btnFanpage.Size = new System.Drawing.Size(200, 40);
            this.btnFanpage.TabIndex = 2;
            this.btnFanpage.Text = "Fanpage";
            this.btnFanpage.UseVisualStyleBackColor = false;
            this.btnFanpage.Click += new System.EventHandler(this.btnFanpage_Click);
            // 
            // panelUserInfo
            // 
            this.panelUserInfo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.panelUserInfo.Controls.Add(this.pictureBoxCash);
            this.panelUserInfo.Controls.Add(this.pictureBoxRefresh);
            this.panelUserInfo.Controls.Add(this.picBoxMenu);
            this.panelUserInfo.Controls.Add(this.lbCash);
            this.panelUserInfo.Controls.Add(this.lbVipLv);
            this.panelUserInfo.Controls.Add(this.lbUsername);
            this.panelUserInfo.Controls.Add(this.linkLbChangePass);
            this.panelUserInfo.Controls.Add(this.yZhWaTiwe);
            this.panelUserInfo.Controls.Add(this.picBoxAvatar);
            this.panelUserInfo.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.panelUserInfo.Location = new System.Drawing.Point(0, 0);
            this.panelUserInfo.Name = "panelUserInfo";
            this.panelUserInfo.Size = new System.Drawing.Size(200, 120);
            this.panelUserInfo.TabIndex = 1;
            // 
            // pictureBoxCash
            // 
            this.pictureBoxCash.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pictureBoxCash.Image = global::Properties.Resources.icon_money;
            this.pictureBoxCash.Location = new System.Drawing.Point(80, 65);
            this.pictureBoxCash.Name = "pictureBoxCash";
            this.pictureBoxCash.Size = new System.Drawing.Size(18, 18);
            this.pictureBoxCash.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBoxCash.TabIndex = 5;
            this.pictureBoxCash.TabStop = false;
            // 
            // pictureBoxRefresh
            // 
            this.pictureBoxRefresh.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pictureBoxRefresh.Image = global::Properties.Resources.cyrus_refresh;
            this.pictureBoxRefresh.Location = new System.Drawing.Point(175, 64);
            this.pictureBoxRefresh.Name = "pictureBoxRefresh";
            this.pictureBoxRefresh.Size = new System.Drawing.Size(20, 20);
            this.pictureBoxRefresh.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBoxRefresh.TabIndex = 4;
            this.pictureBoxRefresh.TabStop = false;
            this.pictureBoxRefresh.Click += new System.EventHandler(this.pictureBoxRefresh_Click);
            // 
            // picBoxMenu
            // 
            this.picBoxMenu.Cursor = System.Windows.Forms.Cursors.Hand;
            this.picBoxMenu.Image = global::Properties.Resources.cyrus_drop_down_menu;
            this.picBoxMenu.Location = new System.Drawing.Point(175, 3);
            this.picBoxMenu.Name = "picBoxMenu";
            this.picBoxMenu.Size = new System.Drawing.Size(20, 25);
            this.picBoxMenu.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picBoxMenu.TabIndex = 3;
            this.picBoxMenu.TabStop = false;
            this.picBoxMenu.Click += new System.EventHandler(this.picBoxMenu_Click);
            // 
            // lbCash
            // 
            this.lbCash.AutoSize = true;
            this.lbCash.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbCash.ForeColor = System.Drawing.Color.White;
            this.lbCash.Location = new System.Drawing.Point(97, 65);
            this.lbCash.Name = "lbCash";
            this.lbCash.Size = new System.Drawing.Size(74, 16);
            this.lbCash.TabIndex = 2;
            this.lbCash.Text = " 999999999";
            // 
            // lbVipLv
            // 
            this.lbVipLv.AutoSize = true;
            this.lbVipLv.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbVipLv.ForeColor = System.Drawing.Color.White;
            this.lbVipLv.Location = new System.Drawing.Point(77, 38);
            this.lbVipLv.Name = "lbVipLv";
            this.lbVipLv.Size = new System.Drawing.Size(46, 16);
            this.lbVipLv.TabIndex = 2;
            this.lbVipLv.Text = "VIP 12";
            // 
            // lbUsername
            // 
            this.lbUsername.AutoSize = true;
            this.lbUsername.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbUsername.ForeColor = System.Drawing.Color.White;
            this.lbUsername.Location = new System.Drawing.Point(77, 11);
            this.lbUsername.Name = "lbUsername";
            this.lbUsername.Size = new System.Drawing.Size(46, 16);
            this.lbUsername.TabIndex = 2;
            this.lbUsername.Text = "Admin";
            // 
            // linkLbChangePass
            // 
            this.linkLbChangePass.ActiveLinkColor = System.Drawing.Color.DodgerBlue;
            this.linkLbChangePass.AutoSize = true;
            this.linkLbChangePass.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLbChangePass.LinkColor = System.Drawing.Color.White;
            this.linkLbChangePass.Location = new System.Drawing.Point(110, 96);
            this.linkLbChangePass.Name = "linkLbChangePass";
            this.linkLbChangePass.Size = new System.Drawing.Size(85, 16);
            this.linkLbChangePass.TabIndex = 1;
            this.linkLbChangePass.TabStop = true;
            this.linkLbChangePass.Text = "Đổi mật khẩu";
            this.linkLbChangePass.VisitedLinkColor = System.Drawing.Color.RoyalBlue;
            this.linkLbChangePass.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLbChangePass_LinkClicked);
            // 
            // yZhWaTiwe
            // 
            this.yZhWaTiwe.ActiveLinkColor = System.Drawing.Color.DodgerBlue;
            this.yZhWaTiwe.AutoSize = true;
            this.yZhWaTiwe.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.yZhWaTiwe.LinkColor = System.Drawing.Color.White;
            this.yZhWaTiwe.Location = new System.Drawing.Point(4, 96);
            this.yZhWaTiwe.Name = "yZhWaTiwe";
            this.yZhWaTiwe.Size = new System.Drawing.Size(68, 16);
            this.yZhWaTiwe.TabIndex = 1;
            this.yZhWaTiwe.TabStop = true;
            this.yZhWaTiwe.Text = "Tài khoản";
            this.yZhWaTiwe.VisitedLinkColor = System.Drawing.Color.RoyalBlue;
            this.yZhWaTiwe.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.yZhWaTiwe_LinkClicked);
            // 
            // picBoxAvatar
            // 
            this.picBoxAvatar.Image = global::Properties.Resources.alpha;
            this.picBoxAvatar.Location = new System.Drawing.Point(6, 7);
            this.picBoxAvatar.Name = "picBoxAvatar";
            this.picBoxAvatar.Size = new System.Drawing.Size(65, 65);
            this.picBoxAvatar.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxAvatar.TabIndex = 0;
            this.picBoxAvatar.TabStop = false;
            // 
            // btnChangeServer
            // 
            this.btnChangeServer.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.btnChangeServer.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.btnChangeServer.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnChangeServer.FlatAppearance.BorderSize = 0;
            this.btnChangeServer.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnChangeServer.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnChangeServer.ForeColor = System.Drawing.Color.White;
            this.btnChangeServer.Image = global::Properties.Resources.cyrus_exchange;
            this.btnChangeServer.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnChangeServer.Location = new System.Drawing.Point(1, 479);
            this.btnChangeServer.Name = "btnChangeServer";
            this.btnChangeServer.Size = new System.Drawing.Size(200, 40);
            this.btnChangeServer.TabIndex = 0;
            this.btnChangeServer.Text = "Đổi máy chủ";
            this.btnChangeServer.UseVisualStyleBackColor = false;
            this.btnChangeServer.Click += new System.EventHandler(this.qSidvyqoK);
            // 
            // btnSupport
            // 
            this.btnSupport.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.btnSupport.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.btnSupport.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnSupport.FlatAppearance.BorderSize = 0;
            this.btnSupport.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnSupport.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSupport.ForeColor = System.Drawing.Color.White;
            this.btnSupport.Image = global::Properties.Resources.cyrus_customer_service;
            this.btnSupport.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnSupport.Location = new System.Drawing.Point(1, 271);
            this.btnSupport.Name = "btnSupport";
            this.btnSupport.Size = new System.Drawing.Size(200, 40);
            this.btnSupport.TabIndex = 0;
            this.btnSupport.Text = "Hỗ trợ";
            this.btnSupport.UseVisualStyleBackColor = false;
            this.btnSupport.Click += new System.EventHandler(this.btnSupport_Click);
            // 
            // btnPay
            // 
            this.btnPay.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.btnPay.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.btnPay.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPay.FlatAppearance.BorderSize = 0;
            this.btnPay.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnPay.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnPay.ForeColor = System.Drawing.Color.White;
            this.btnPay.Image = global::Properties.Resources.cyrus_pay;
            this.btnPay.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnPay.Location = new System.Drawing.Point(1, 228);
            this.btnPay.Name = "btnPay";
            this.btnPay.Size = new System.Drawing.Size(200, 40);
            this.btnPay.TabIndex = 0;
            this.btnPay.Text = "Nạp thẻ";
            this.btnPay.UseVisualStyleBackColor = false;
            this.btnPay.Click += new System.EventHandler(this.btnPay_Click);
            // 
            // btnPlayGame
            // 
            this.btnPlayGame.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.btnPlayGame.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.btnPlayGame.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPlayGame.FlatAppearance.BorderSize = 0;
            this.btnPlayGame.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnPlayGame.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnPlayGame.ForeColor = System.Drawing.Color.White;
            this.btnPlayGame.Image = global::Properties.Resources.cyrus_game_console;
            this.btnPlayGame.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnPlayGame.Location = new System.Drawing.Point(1, 185);
            this.btnPlayGame.Name = "btnPlayGame";
            this.btnPlayGame.Size = new System.Drawing.Size(200, 40);
            this.btnPlayGame.TabIndex = 0;
            this.btnPlayGame.Text = "Chơi game";
            this.btnPlayGame.UseVisualStyleBackColor = false;
            this.btnPlayGame.Click += new System.EventHandler(this.btnPlayGame_Click);
            // 
            // btnHome
            // 
            this.btnHome.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.btnHome.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.btnHome.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnHome.FlatAppearance.BorderSize = 0;
            this.btnHome.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnHome.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnHome.ForeColor = System.Drawing.Color.White;
            this.btnHome.Image = global::Properties.Resources.cyrus_home;
            this.btnHome.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnHome.Location = new System.Drawing.Point(1, 139);
            this.btnHome.Name = "btnHome";
            this.btnHome.Size = new System.Drawing.Size(200, 40);
            this.btnHome.TabIndex = 0;
            this.btnHome.Text = "Trang chủ";
            this.btnHome.UseVisualStyleBackColor = false;
            this.btnHome.Click += new System.EventHandler(this.efThmTvYq_Click);
            // 
            // btmSignOut
            // 
            this.btmSignOut.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(81)))), ((int)(((byte)(33)))), ((int)(((byte)(1)))));
            this.btmSignOut.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.btmSignOut.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btmSignOut.FlatAppearance.BorderSize = 0;
            this.btmSignOut.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btmSignOut.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btmSignOut.ForeColor = System.Drawing.Color.White;
            this.btmSignOut.Image = global::Properties.Resources.cyrus_logout;
            this.btmSignOut.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btmSignOut.Location = new System.Drawing.Point(0, 585);
            this.btmSignOut.Name = "btmSignOut";
            this.btmSignOut.Size = new System.Drawing.Size(200, 40);
            this.btmSignOut.TabIndex = 0;
            this.btmSignOut.Text = "Đăng xuất";
            this.btmSignOut.UseVisualStyleBackColor = false;
            this.btmSignOut.Click += new System.EventHandler(this.btmSignOut_Click);
            // 
            // panelMain
            // 
            this.panelMain.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(237)))), ((int)(((byte)(240)))));
            this.panelMain.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.panelMain.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelMain.Location = new System.Drawing.Point(200, 30);
            this.panelMain.Name = "panelMain";
            this.panelMain.Size = new System.Drawing.Size(1000, 635);
            this.panelMain.TabIndex = 2;
            // 
            // timer_0
            // 
            this.timer_0.Interval = 1000;
            this.timer_0.Tick += new System.EventHandler(this.timer_0_Tick);
            // 
            // timer_1
            // 
            this.timer_1.Interval = 5000;
            this.timer_1.Tick += new System.EventHandler(this.inYpCcGpy);
            // 
            // Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1200, 665);
            this.Controls.Add(this.panelMain);
            this.Controls.Add(this.panelLeftMenu);
            this.Controls.Add(this.panelTitle);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Main";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Main";
            this.Activated += new System.EventHandler(this.Main_Activated);
            this.Load += new System.EventHandler(this.Main_Load);
            this.Shown += new System.EventHandler(this.Main_Shown);
            this.Resize += new System.EventHandler(this.Main_Resize);
            this.panelTitle.ResumeLayout(false);
            this.panelTitle.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.btnMaxSize)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxMinimum)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxClose)).EndInit();
            this.panelLeftMenu.ResumeLayout(false);
            this.panelUserInfo.ResumeLayout(false);
            this.panelUserInfo.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxCash)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxRefresh)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxMenu)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxAvatar)).EndInit();
            this.ResumeLayout(false);

		}

		[CompilerGenerated]
		private void method_6(string string_1, string string_2)
		{
			Invoke((Action)delegate
			{
				dThycgdc8(string_1, string_2);
			});
		}

		internal static void k3CQcJ0xw6QCbsjtr6()
		{
		}

		internal static bool pjLr4rmCUoW4SC8qkT()
		{
			return fyCAuH2U8EHSdWX235 == null;
		}

		internal static void B2oJrK8uE8QhfbP8hsn()
		{
		}

        private void btnMaxSize_Click(object sender, EventArgs e)
        {
            if (WindowState == FormWindowState.Normal)
            {
				WindowState = FormWindowState.Maximized;
            }
            else
            {
				WindowState = FormWindowState.Normal;
			}
        }

        private void btnFanpage_Click(object sender, EventArgs e)
        {
            Process.Start("https://www.facebook.com/gun3mien/");
        }

        private void btnGroup_Click(object sender, EventArgs e)
        {
            Process.Start("https://www.facebook.com/groups/gun3m/");
        }
    }
}
