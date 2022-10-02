using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;
using Launcher.Popup;
using Launcher.Properties;
using Launcher.Statics;
using Launcher.Update;
using Newtonsoft.Json;
using Properties;

namespace Launcher.Forms
{
	public class Login : Form
	{
		private List<string> list_0;

		private HistoryAccount historyAccount_0;

		private IContainer icontainer_0;

		private Panel panelLogo;

		private PictureBox picBoxLogo;

		private Panel panelHeader;

		private PictureBox picBoxGameLogo;

		private Button btnLogin;

		private TextBox txtPassword;

		private TextBox txtAccount;

		private LinkLabel linkLbRegister;

		private LinkLabel linkLbForgotPass;

		private PictureBox picBoxMin;

		private PictureBox picBoxClose;

		private Label lbErrors;

		private Panel panelMain;

		private PictureBox picBoxLinePassword;

		private PictureBox picBoxLineAccount;

		private Label lbVersion;

		private LinkLabel lbHistoryAccount;

		internal static Login Tw5uAFXkfrZetKjKJ04;

		private string APPLICATION_DATA_FOLDER = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);

		public Login()
		{
			InitializeComponent();
		}

		private void method_0()
		{
			string text = new HackTools().FindHack();
			if (!string.IsNullOrEmpty(text))
			{
				MessageBox.Show("Phát hiện bạn đang dùng phần mềm cấm: " + text);
				Application.Exit();
			}
		}

		private void Login_Load(object sender, EventArgs e)
		{
			method_0();
			txtPassword.Text = Resources.Password;
			txtPassword.UseSystemPasswordChar = false;
			txtAccount.Text = Resources.Account;
			lbErrors.Visible = false;
			if (!string.IsNullOrEmpty(DDTStaticFunc.DefaulAccount))
			{
				txtAccount.Text = DDTStaticFunc.DefaulAccount;
			}
			if (!string.IsNullOrEmpty(DDTStaticFunc.DefaultPassword))
			{
				txtPassword.UseSystemPasswordChar = true;
				txtPassword.Text = DDTStaticFunc.DefaultPassword;
			}
			DDTStaticFunc.AddUpdateLogs("Location", Assembly.GetExecutingAssembly().Location);
			lbVersion.Text = Assembly.GetExecutingAssembly().GetName().Version.ToString();
			//Text = Assembly.GetExecutingAssembly().GetName().Name + " - ver." + lbVersion.Text;
			Text = ServerConfig.SiteName + " - ver." + lbVersion.Text;
			LoadSavedAccount();
		}

		private void LoadSavedAccount()
		{
			list_0 = new List<string>();
			try
			{
				if (!File.Exists(LoginMgr.UserPath + Resources.LogFile))
				{
					return;
				}
				byte[] data = File.ReadAllBytes(LoginMgr.UserPath + Resources.LogFile);
				byte[] bytes = RC4.Decrypt(Encoding.UTF8.GetBytes(Resources.LocalKey), data);
				Dictionary<string, string> dictionary = JsonConvert.DeserializeObject<Dictionary<string, string>>(Encoding.UTF8.GetString(bytes));
				foreach (string key in dictionary.Keys)
				{
					LoginMgr.AddAccount(key, dictionary[key]);
					list_0.Add(key);
				}
			}
			catch
			{
			}
		}

		[DllImport("user32.DLL")]
		private static extern void ReleaseCapture();

		[DllImport("user32.DLL")]
		private static extern void SendMessage(IntPtr intptr_0, int int_0, int int_1, int int_2);

		private void Login_MouseDown(object sender, MouseEventArgs e)
		{
			ReleaseCapture();
			SendMessage(base.Handle, 274, 61458, 0);
		}

		private void showMessage(string message)
		{
			lbErrors.Text = "       " + message;
			lbErrors.Visible = true;
		}

		private void method_3(object sender, FormClosedEventArgs e)
		{
			txtPassword.Text = Resources.Password;
			txtPassword.UseSystemPasswordChar = false;
			txtAccount.Text = Resources.Account;
			lbErrors.Visible = false;
			showHandCursor(bool_0: true);
			LoadSavedAccount();
			Show();
		}

		private void CloseLoginForm()
		{
			LoginMgr.AddAccount(txtAccount.Text.ToLower(), txtPassword.Text);
			LoginMgr.Save();
			Hide();
			Main main = new Main();
			new Welcome().ShowDialog();
			main.Show();
			main.FormClosed += method_3;
		}

		private void showHandCursor(bool bool_0)
		{
			if (bool_0)
			{
				btnLogin.Cursor = Cursors.Hand;
				btnLogin.Enabled = true;
			}
			else
			{
				btnLogin.Cursor = Cursors.No;
				btnLogin.Enabled = false;
			}
		}

		public void LoginSaveAccount(string acc)
		{
			string savePassword = LoginMgr.GetSavePassword(acc);
			txtAccount.Text = acc;
			if (!string.IsNullOrEmpty(savePassword))
			{
				txtPassword.Text = savePassword;
				txtPassword.ForeColor = Color.WhiteSmoke;
				txtPassword.UseSystemPasswordChar = true;
			}
			historyAccount_0.Close();
			historyAccount_0.Dispose();
			historyAccount_0 = null;
			btnLogin_Click(null, null);
		}

		private void RemoveDirectories(string strpath)
		{
			foreach (FileSystemInfo file in new DirectoryInfo(strpath).GetFiles())
				file.Delete();
			foreach (DirectoryInfo directory in new DirectoryInfo(strpath).GetDirectories())
				directory.Delete(true);
		}

		private void btnLogin_Click(object sender, EventArgs e)
		{
			string text = txtAccount.Text.ToLower();
			string text2 = txtPassword.Text;
			if (!(txtAccount.Text != Resources.Account) || text.Length < 2)
			{
				showMessage("Chưa nhập tài khoản.");
			}
			else if (txtPassword.Text != Resources.Password && txtPassword.UseSystemPasswordChar)
			{
				string text3 = Util.MD5(text + text2 + Resources.PublicKey);
				showHandCursor(false);
				showMessage("Đang tải vui lòng chờ!");
				try
				{
					NameValueCollection param = new NameValueCollection
					{
						{ "u", text },
						{ "p", text2 },
						{ "key", text3 }
					};
					DDTStaticFunc.AddUpdateLogs("Post data", "u:" + text + ", p:" + text2 + ", k:" + text3 + ", url:" + DDTStaticFunc.LoginUrl);
					string text4 = ControlMgr.Post(DDTStaticFunc.LoginUrl, param);
					if (!string.IsNullOrEmpty(text4) && text4.IndexOf("true") != -1)
					{
						if (!ServerConfig.Init(text4))
						{
							showHandCursor(true);
							showMessage("Tải thông tin thất bại!");
						}
						else
						{
							string AdobeFlash = this.APPLICATION_DATA_FOLDER + "\\Adobe\\Flash Player";
							string MacromediaFlash = this.APPLICATION_DATA_FOLDER + "\\Macromedia\\Flash Player";
							if (Directory.Exists(AdobeFlash))
                            {
								Process.Start("rundll32.exe", "InetCpl.cpl,ClearMyTracksByProcess 255");
								RemoveDirectories(AdobeFlash);
							}
                            if (Directory.Exists(MacromediaFlash))
                            {
								Process.Start("rundll32.exe", "InetCpl.cpl,ClearMyTracksByProcess 255");
								RemoveDirectories(MacromediaFlash);
							}
							LoginMgr.Login(text, text2);
							CloseLoginForm();
						}
					}
					else
					{
						showHandCursor(true);
						if (text4.StartsWith("System."))
						{
							DDTStaticFunc.AddUpdateLogs("Login post error", text4);
							showMessage("Kết nối máy chủ thất bại, vui lòng kiễm tra lại kết nối internet!");
						}
						else
						{
							showMessage(text4);
							DDTStaticFunc.AddUpdateLogs("Response from server", "u:" + text + ", p:" + text2 + ", k:" + text3 + ", data:" + text4);
						}
					}
				}
				catch (Exception ex)
				{
					showHandCursor(true);
					showMessage(ex.Message);
					DDTStaticFunc.AddUpdateLogs("Exception 1 " + ex.Message, $"u:{text}, p:{text2}, k:{text3}, error:{ex}");
				}
				txtPassword.Text = Resources.Password;
				txtPassword.UseSystemPasswordChar = false;
				txtAccount.Focus();
			}
			else
			{
				showMessage("Chưa nhập mật khẩu.");
			}
		}

		private void linkLbRegister_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			new Register().ShowDialog();
		}

		private void linkLbForgotPass_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			new ForgotPassword().ShowDialog();
			//MessageBox.Show("Chức năng chưa ra mắt");
		}

		private void picBoxClose_Click(object sender, EventArgs e)
		{
			Application.Exit();
		}

		private void picBoxClose_MouseHover(object sender, EventArgs e)
		{
			picBoxClose.Image = Resources.icons8_close_window_40_red;
		}

		private void picBoxClose_MouseLeave(object sender, EventArgs e)
		{
			picBoxClose.Image = Resources.icons8_close_window_40;
		}

		private void picBoxMin_Click(object sender, EventArgs e)
		{
			base.WindowState = FormWindowState.Minimized;
		}

		private void picBoxMin_MouseHover(object sender, EventArgs e)
		{
			picBoxMin.Image = Resources.minimazar_red;
		}

		private void picBoxMin_MouseLeave(object sender, EventArgs e)
		{
			picBoxMin.Image = Resources.minimazar;
		}

		private void txtAccount_Enter(object sender, EventArgs e)
		{
			if (txtAccount.Text == Resources.Account)
			{
				txtAccount.Text = "";
				txtAccount.ForeColor = Color.FromArgb(37, 114, 230);//Color.WhiteSmoke;
			}
		}

		private void txtAccount_Leave(object sender, EventArgs e)
		{
			if (txtAccount.Text == "")
			{
				txtAccount.Text = Resources.Account;
				txtAccount.ForeColor = Color.FromArgb(37, 114, 230);//Color.Silver;
			}
		}

		private void txtPassword_Enter(object sender, EventArgs e)
		{
			if (txtPassword.Text == Resources.Password)
			{
				txtPassword.Text = "";
				txtPassword.ForeColor = Color.FromArgb(37, 114, 230);//Color.WhiteSmoke;
				txtPassword.UseSystemPasswordChar = true;
			}
		}

		private void txtPassword_Leave(object sender, EventArgs e)
		{
			if (txtPassword.Text == "")
			{
				txtPassword.Text = Resources.Password;
				txtPassword.ForeColor = Color.FromArgb(37, 114, 230);//Color.Silver;
				txtPassword.UseSystemPasswordChar = false;
			}
		}

		private void txtAccount_TextChanged(object sender, EventArgs e)
		{
			if (!string.IsNullOrEmpty(txtAccount.Text) && txtAccount.Text != Resources.Account)
			{
				string.IsNullOrEmpty(LoginMgr.GetSavePassword(txtAccount.Text));
			}
		}

		private void Login_KeyDown(object sender, KeyEventArgs e)
		{
			if (e.KeyCode == Keys.Return)
			{
				btnLogin.PerformClick();
			}
		}

		private void txtAccount_KeyDown(object sender, KeyEventArgs e)
		{
			if (e.KeyCode == Keys.Return)
			{
				btnLogin.PerformClick();
			}
		}

		private void txtPassword_KeyDown(object sender, KeyEventArgs e)
		{
			if (e.KeyCode == Keys.Return)
			{
				btnLogin.PerformClick();
			}
		}

		private void lbHistoryAccount_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			if (historyAccount_0 == null)
			{
				historyAccount_0 = new HistoryAccount(this, list_0);
				historyAccount_0.ShowDialog();
			}
			else
			{
				historyAccount_0.ShowDialog();
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Login));
            this.panelLogo = new System.Windows.Forms.Panel();
            this.lbVersion = new System.Windows.Forms.Label();
            this.picBoxLogo = new System.Windows.Forms.PictureBox();
            this.panelHeader = new System.Windows.Forms.Panel();
            this.picBoxMin = new System.Windows.Forms.PictureBox();
            this.picBoxClose = new System.Windows.Forms.PictureBox();
            this.picBoxGameLogo = new System.Windows.Forms.PictureBox();
            this.btnLogin = new System.Windows.Forms.Button();
            this.txtPassword = new System.Windows.Forms.TextBox();
            this.txtAccount = new System.Windows.Forms.TextBox();
            this.linkLbRegister = new System.Windows.Forms.LinkLabel();
            this.linkLbForgotPass = new System.Windows.Forms.LinkLabel();
            this.lbErrors = new System.Windows.Forms.Label();
            this.panelMain = new System.Windows.Forms.Panel();
            this.lbHistoryAccount = new System.Windows.Forms.LinkLabel();
            this.picBoxLinePassword = new System.Windows.Forms.PictureBox();
            this.picBoxLineAccount = new System.Windows.Forms.PictureBox();
            this.panelLogo.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxLogo)).BeginInit();
            this.panelHeader.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxMin)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxClose)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxGameLogo)).BeginInit();
            this.panelMain.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxLinePassword)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxLineAccount)).BeginInit();
            this.SuspendLayout();
            // 
            // panelLogo
            // 
            this.panelLogo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(100)))), ((int)(((byte)(182)))));
            this.panelLogo.Controls.Add(this.lbVersion);
            this.panelLogo.Controls.Add(this.picBoxLogo);
            this.panelLogo.Dock = System.Windows.Forms.DockStyle.Left;
            this.panelLogo.Location = new System.Drawing.Point(0, 0);
            this.panelLogo.Name = "panelLogo";
            this.panelLogo.Size = new System.Drawing.Size(302, 329);
            this.panelLogo.TabIndex = 0;
            // 
            // lbVersion
            // 
            this.lbVersion.AutoSize = true;
            this.lbVersion.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(236)))), ((int)(((byte)(191)))), ((int)(((byte)(88)))));
            this.lbVersion.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbVersion.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(70)))), ((int)(((byte)(118)))), ((int)(((byte)(126)))));
            this.lbVersion.Location = new System.Drawing.Point(5, 311);
            this.lbVersion.Name = "lbVersion";
            this.lbVersion.Size = new System.Drawing.Size(40, 13);
            this.lbVersion.TabIndex = 2;
            this.lbVersion.Text = "1.0.0.1";
            // 
            // picBoxLogo
            // 
            this.picBoxLogo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(215)))), ((int)(((byte)(67)))));
            this.picBoxLogo.Dock = System.Windows.Forms.DockStyle.Fill;
            this.picBoxLogo.Image = global::Properties.Resources.gun;
            this.picBoxLogo.Location = new System.Drawing.Point(0, 0);
            this.picBoxLogo.Name = "picBoxLogo";
            this.picBoxLogo.Size = new System.Drawing.Size(302, 329);
            this.picBoxLogo.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxLogo.TabIndex = 0;
            this.picBoxLogo.TabStop = false;
            this.picBoxLogo.MouseDown += new System.Windows.Forms.MouseEventHandler(this.Login_MouseDown);
            // 
            // panelHeader
            // 
            this.panelHeader.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(215)))), ((int)(((byte)(67)))));
            this.panelHeader.Controls.Add(this.picBoxMin);
            this.panelHeader.Controls.Add(this.picBoxClose);
            this.panelHeader.Controls.Add(this.picBoxGameLogo);
            this.panelHeader.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelHeader.Location = new System.Drawing.Point(302, 0);
            this.panelHeader.Name = "panelHeader";
            this.panelHeader.Size = new System.Drawing.Size(478, 100);
            this.panelHeader.TabIndex = 1;
            this.panelHeader.MouseDown += new System.Windows.Forms.MouseEventHandler(this.Login_MouseDown);
            // 
            // picBoxMin
            // 
            this.picBoxMin.Image = global::Properties.Resources.minimazar_red;
            this.picBoxMin.Location = new System.Drawing.Point(434, 9);
            this.picBoxMin.Name = "picBoxMin";
            this.picBoxMin.Size = new System.Drawing.Size(15, 15);
            this.picBoxMin.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picBoxMin.TabIndex = 1;
            this.picBoxMin.TabStop = false;
            this.picBoxMin.Click += new System.EventHandler(this.picBoxMin_Click);
            this.picBoxMin.MouseLeave += new System.EventHandler(this.picBoxMin_MouseLeave);
            this.picBoxMin.MouseHover += new System.EventHandler(this.picBoxMin_MouseHover);
            // 
            // picBoxClose
            // 
            this.picBoxClose.Image = global::Properties.Resources.icons8_close_window_40_red;
            this.picBoxClose.Location = new System.Drawing.Point(454, 9);
            this.picBoxClose.Name = "picBoxClose";
            this.picBoxClose.Size = new System.Drawing.Size(15, 15);
            this.picBoxClose.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picBoxClose.TabIndex = 1;
            this.picBoxClose.TabStop = false;
            this.picBoxClose.Click += new System.EventHandler(this.picBoxClose_Click);
            this.picBoxClose.MouseLeave += new System.EventHandler(this.picBoxClose_MouseLeave);
            this.picBoxClose.MouseHover += new System.EventHandler(this.picBoxClose_MouseHover);
            // 
            // picBoxGameLogo
            // 
            this.picBoxGameLogo.Image = global::Properties.Resources.logoGunny;
            this.picBoxGameLogo.Location = new System.Drawing.Point(150, 3);
            this.picBoxGameLogo.Name = "picBoxGameLogo";
            this.picBoxGameLogo.Size = new System.Drawing.Size(185, 94);
            this.picBoxGameLogo.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picBoxGameLogo.TabIndex = 0;
            this.picBoxGameLogo.TabStop = false;
            this.picBoxGameLogo.MouseDown += new System.Windows.Forms.MouseEventHandler(this.Login_MouseDown);
            // 
            // btnLogin
            // 
            this.btnLogin.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(170)))), ((int)(((byte)(251)))), ((int)(((byte)(1)))));
            this.btnLogin.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnLogin.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(64)))), ((int)(((byte)(0)))));
            this.btnLogin.FlatAppearance.MouseDownBackColor = System.Drawing.Color.DarkGreen;
            this.btnLogin.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(64)))), ((int)(((byte)(0)))));
            this.btnLogin.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnLogin.Font = new System.Drawing.Font("Microsoft Tai Le", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnLogin.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(94)))), ((int)(((byte)(61)))), ((int)(((byte)(0)))));
            this.btnLogin.Location = new System.Drawing.Point(45, 146);
            this.btnLogin.Name = "btnLogin";
            this.btnLogin.Size = new System.Drawing.Size(398, 45);
            this.btnLogin.TabIndex = 3;
            this.btnLogin.Text = "ĐĂNG NHẬP";
            this.btnLogin.UseVisualStyleBackColor = false;
            this.btnLogin.Click += new System.EventHandler(this.btnLogin_Click);
            // 
            // txtPassword
            // 
            this.txtPassword.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(254)))), ((int)(((byte)(237)))), ((int)(((byte)(162)))));
            this.txtPassword.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.txtPassword.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtPassword.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(94)))), ((int)(((byte)(61)))), ((int)(((byte)(0)))));
            this.txtPassword.Location = new System.Drawing.Point(45, 68);
            this.txtPassword.Name = "txtPassword";
            this.txtPassword.Size = new System.Drawing.Size(398, 19);
            this.txtPassword.TabIndex = 2;
            this.txtPassword.Text = "Mật khẩu";
            this.txtPassword.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtPassword.Enter += new System.EventHandler(this.txtPassword_Enter);
            this.txtPassword.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtPassword_KeyDown);
            this.txtPassword.Leave += new System.EventHandler(this.txtPassword_Leave);
            // 
            // txtAccount
            // 
            this.txtAccount.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Suggest;
            this.txtAccount.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(254)))), ((int)(((byte)(237)))), ((int)(((byte)(162)))));
            this.txtAccount.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.txtAccount.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtAccount.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(94)))), ((int)(((byte)(61)))), ((int)(((byte)(0)))));
            this.txtAccount.Location = new System.Drawing.Point(45, 31);
            this.txtAccount.Name = "txtAccount";
            this.txtAccount.Size = new System.Drawing.Size(398, 19);
            this.txtAccount.TabIndex = 1;
            this.txtAccount.Text = "Tài khoản";
            this.txtAccount.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtAccount.TextChanged += new System.EventHandler(this.txtAccount_TextChanged);
            this.txtAccount.Enter += new System.EventHandler(this.txtAccount_Enter);
            this.txtAccount.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtAccount_KeyDown);
            this.txtAccount.Leave += new System.EventHandler(this.txtAccount_Leave);
            // 
            // linkLbRegister
            // 
            this.linkLbRegister.ActiveLinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(243)))), ((int)(((byte)(57)))), ((int)(((byte)(80)))));
            this.linkLbRegister.AutoSize = true;
            this.linkLbRegister.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(131)))), ((int)(((byte)(64)))), ((int)(((byte)(0)))));
            this.linkLbRegister.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(128)))), ((int)(((byte)(0)))));
            this.linkLbRegister.LinkColor = System.Drawing.Color.White;
            this.linkLbRegister.Location = new System.Drawing.Point(45, 204);
            this.linkLbRegister.Name = "linkLbRegister";
            this.linkLbRegister.Size = new System.Drawing.Size(180, 16);
            this.linkLbRegister.TabIndex = 13;
            this.linkLbRegister.TabStop = true;
            this.linkLbRegister.Text = "Không có tài khoản? Đăng ký";
            this.linkLbRegister.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLbRegister_LinkClicked);
            // 
            // linkLbForgotPass
            // 
            this.linkLbForgotPass.ActiveLinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLbForgotPass.AutoSize = true;
            this.linkLbForgotPass.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(131)))), ((int)(((byte)(64)))), ((int)(((byte)(0)))));
            this.linkLbForgotPass.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(128)))), ((int)(((byte)(0)))));
            this.linkLbForgotPass.LinkColor = System.Drawing.Color.White;
            this.linkLbForgotPass.Location = new System.Drawing.Point(350, 204);
            this.linkLbForgotPass.Name = "linkLbForgotPass";
            this.linkLbForgotPass.Size = new System.Drawing.Size(97, 16);
            this.linkLbForgotPass.TabIndex = 14;
            this.linkLbForgotPass.TabStop = true;
            this.linkLbForgotPass.Text = "Quên mật khẩu";
            this.linkLbForgotPass.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLbForgotPass_LinkClicked);
            // 
            // lbErrors
            // 
            this.lbErrors.AutoSize = true;
            this.lbErrors.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(131)))), ((int)(((byte)(64)))), ((int)(((byte)(0)))));
            this.lbErrors.ForeColor = System.Drawing.Color.White;
            this.lbErrors.Image = global::Properties.Resources.error;
            this.lbErrors.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lbErrors.Location = new System.Drawing.Point(45, 110);
            this.lbErrors.Name = "lbErrors";
            this.lbErrors.Size = new System.Drawing.Size(136, 16);
            this.lbErrors.TabIndex = 15;
            this.lbErrors.Text = "       Messenger Errors";
            // 
            // panelMain
            // 
            this.panelMain.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(215)))), ((int)(((byte)(67)))));
            this.panelMain.Controls.Add(this.lbErrors);
            this.panelMain.Controls.Add(this.lbHistoryAccount);
            this.panelMain.Controls.Add(this.linkLbForgotPass);
            this.panelMain.Controls.Add(this.linkLbRegister);
            this.panelMain.Controls.Add(this.btnLogin);
            this.panelMain.Controls.Add(this.txtPassword);
            this.panelMain.Controls.Add(this.txtAccount);
            this.panelMain.Controls.Add(this.picBoxLinePassword);
            this.panelMain.Controls.Add(this.picBoxLineAccount);
            this.panelMain.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelMain.Location = new System.Drawing.Point(302, 100);
            this.panelMain.Name = "panelMain";
            this.panelMain.Size = new System.Drawing.Size(478, 229);
            this.panelMain.TabIndex = 16;
            // 
            // lbHistoryAccount
            // 
            this.lbHistoryAccount.ActiveLinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(236)))), ((int)(((byte)(191)))), ((int)(((byte)(88)))));
            this.lbHistoryAccount.AutoSize = true;
            this.lbHistoryAccount.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(131)))), ((int)(((byte)(64)))), ((int)(((byte)(0)))));
            this.lbHistoryAccount.DisabledLinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(131)))), ((int)(((byte)(64)))), ((int)(((byte)(0)))));
            this.lbHistoryAccount.LinkColor = System.Drawing.Color.White;
            this.lbHistoryAccount.Location = new System.Drawing.Point(293, 9);
            this.lbHistoryAccount.Name = "lbHistoryAccount";
            this.lbHistoryAccount.Size = new System.Drawing.Size(154, 16);
            this.lbHistoryAccount.TabIndex = 14;
            this.lbHistoryAccount.TabStop = true;
            this.lbHistoryAccount.Text = "Tài khoản đã đăng nhập";
            this.lbHistoryAccount.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lbHistoryAccount_LinkClicked);
            // 
            // picBoxLinePassword
            // 
            this.picBoxLinePassword.Image = global::Properties.Resources.lineShape;
            this.picBoxLinePassword.Location = new System.Drawing.Point(45, 69);
            this.picBoxLinePassword.Name = "picBoxLinePassword";
            this.picBoxLinePassword.Size = new System.Drawing.Size(398, 20);
            this.picBoxLinePassword.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxLinePassword.TabIndex = 16;
            this.picBoxLinePassword.TabStop = false;
            // 
            // picBoxLineAccount
            // 
            this.picBoxLineAccount.Image = global::Properties.Resources.lineShape;
            this.picBoxLineAccount.Location = new System.Drawing.Point(45, 32);
            this.picBoxLineAccount.Name = "picBoxLineAccount";
            this.picBoxLineAccount.Size = new System.Drawing.Size(398, 20);
            this.picBoxLineAccount.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxLineAccount.TabIndex = 16;
            this.picBoxLineAccount.TabStop = false;
            // 
            // Login
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(32)))), ((int)(((byte)(47)))), ((int)(((byte)(66)))));
            this.ClientSize = new System.Drawing.Size(780, 329);
            this.Controls.Add(this.panelMain);
            this.Controls.Add(this.panelHeader);
            this.Controls.Add(this.panelLogo);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "Login";
            this.Opacity = 0.9D;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "7";
            this.Load += new System.EventHandler(this.Login_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.Login_KeyDown);
            this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.Login_MouseDown);
            this.panelLogo.ResumeLayout(false);
            this.panelLogo.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxLogo)).EndInit();
            this.panelHeader.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.picBoxMin)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxClose)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxGameLogo)).EndInit();
            this.panelMain.ResumeLayout(false);
            this.panelMain.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxLinePassword)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxLineAccount)).EndInit();
            this.ResumeLayout(false);

		}

		internal static void AN3ldQXvojKtRLOaxob()
		{
		}

		internal static void X9RvFxX7MErqrR1R0SK()
		{
		}

		internal static bool gGe2A7XCCS4EWtJ4dkm()
		{
			return Tw5uAFXkfrZetKjKJ04 == null;
		}

		internal static void h6a0xHO4XKLLenpTKbU()
		{
		}
	}
}
