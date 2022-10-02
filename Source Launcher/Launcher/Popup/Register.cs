using System;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;
using Launcher.Properties;
using Launcher.Statics;
using Properties;

namespace Launcher.Popup
{
	public class Register : Form
	{
		private BackgroundWorker backgroundWorker_0;

		private int currentTick = 1;

		private IContainer icontainer_0;

		private Panel panelHeader;

		private PictureBox picBoxClose;

		private Panel panelContent;

		private Label label1;

		private PictureBox pictureBox1;

		private Button btnRegester;

		private TextBox txtConfirmPassword;

		private Label label5;

		private TextBox txtPassword;

		private Label label4;

		private TextBox txtPhone;

		private Label label3;

		private TextBox txtUsername;

		private Label label2;

		private Timer timer1;

		private Label lbMsg;

		private static Register gTQoux48LprwMmLCPV5;

		public Register()
		{
			InitializeComponent();
			backgroundWorker_0 = new BackgroundWorker
			{
				WorkerReportsProgress = true,
				WorkerSupportsCancellation = true
			};
			backgroundWorker_0.DoWork += backgroundWorker_0_DoWork;
			backgroundWorker_0.RunWorkerCompleted += backgroundWorker_0_RunWorkerCompleted;
			backgroundWorker_0.ProgressChanged += backgroundWorker_0_ProgressChanged;
		}

		private void backgroundWorker_0_ProgressChanged(object sender, ProgressChangedEventArgs e)
		{
		}

		private void backgroundWorker_0_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
		{
			timer1.Stop();
			btnRegester.Enabled = true;
			btnRegester.Text = "Xác nhận";
		}

		private void backgroundWorker_0_DoWork(object sender, DoWorkEventArgs e)
		{
			string text = txtUsername.Text;
			string text2 = txtPassword.Text;
			string text3 = txtPhone.Text;
			string localIPAddress = DDTStaticFunc.GetLocalIPAddress();
			string value = Convert.ToBase64String(ControlMgr.CryptData(text + "|" + text2 + "|" + text3 + "|" + Util.MD5(text + text2 + text3 + Resources.PublicKey) + "|" + localIPAddress));
			NameValueCollection param = new NameValueCollection { { "token", value } };
			string text4 = ControlMgr.Post(DDTStaticFunc.Host + Resources.Register, param);
			try
			{
				string[] array = text4.Split('|');
				if (array.Length == 2)
				{
					if (array[0] == "1")
					{
						SetColor(Color.Green);
					}
					SetText(array[1]);
				}
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception BackWorkerRequestRegisterExchange_DoWork " + ex.Message, $"result:{text4},  \nerrors:{ex}");
			}
			SetCursor(Cursors.Default);
		}

		delegate void SetTextCallback(string text);

		private void SetText(string text)
		{
			// InvokeRequired required compares the thread ID of the
			// calling thread to the thread ID of the creating thread.
			// If these threads are different, it returns true.
			if (this.lbMsg.InvokeRequired)
			{
				SetTextCallback d = new SetTextCallback(SetText);
				this.Invoke(d, new object[] { text });
			}
			else
			{
				this.lbMsg.Text = text;
			}
		}

		delegate void SetColorCallback(Color color);

		private void SetColor(Color color)
		{
			// InvokeRequired required compares the thread ID of the
			// calling thread to the thread ID of the creating thread.
			// If these threads are different, it returns true.
			if (this.lbMsg.InvokeRequired)
			{
				SetColorCallback d = new SetColorCallback(SetColor);
				this.Invoke(d, new object[] { color });
			}
			else
			{
				this.lbMsg.ForeColor = color;
			}
		}

		delegate void SetCursorCallback(Cursor cursor);

		private void SetCursor(Cursor cursor)
		{
			// InvokeRequired required compares the thread ID of the
			// calling thread to the thread ID of the creating thread.
			// If these threads are different, it returns true.
			if (this.InvokeRequired)
			{
				SetCursorCallback d = new SetCursorCallback(SetCursor);
				this.Invoke(d, new object[] { cursor });
			}
			else
			{
				Cursor = cursor;
			}
		}

		private void picBoxClose_Click(object sender, EventArgs e)
		{
			Hide();
		}

		private void picBoxClose_MouseHover(object sender, EventArgs e)
		{
			picBoxClose.Image = Resources.icons8_close_window_40_red;
		}

		private void picBoxClose_MouseLeave(object sender, EventArgs e)
		{
			picBoxClose.Image = Resources.icons8_close_window_40;
		}

		private void btnRegister_Click(object sender, EventArgs e)
		{
			currentTick = 1;
			lbMsg.Visible = true;
			lbMsg.Text = "";
			lbMsg.ForeColor = Color.Red;
			if (string.IsNullOrEmpty(txtUsername.Text))
			{
				lbMsg.Text = "Tài khoản không được để trống!";
			}
			else if (txtUsername.Text.Length < 2)
			{
				lbMsg.Text = "Tài khoản quá ngắn!";
			}
			else if (string.IsNullOrEmpty(txtPhone.Text))
			{
				lbMsg.Text = "Số DT không được để trống!";
			}
			else if (!string.IsNullOrEmpty(txtPassword.Text))
			{
				if (string.IsNullOrEmpty(txtConfirmPassword.Text))
				{
					lbMsg.Text = "Xác nhận mật khẩu không được để trống!";
					return;
				}
				if (txtPassword.Text.Length < 6)
				{
					lbMsg.Text = "Mật Khẩu quá ngắn!";
					return;
				}
				if (!(txtPassword.Text == txtConfirmPassword.Text))
				{
					lbMsg.Text = "Mật khẩu và Xác nhận mật khẩu không trùng khớp.";
					return;
				}
				Cursor = Cursors.WaitCursor;
				btnRegester.Enabled = false;
				timer1.Start();
			}
			else
			{
				lbMsg.Text = "Mật Khẩu không được để trống!";
			}
		}

		private void timer1_Tick(object sender, EventArgs e)
		{
			btnRegester.Text = $"Đang xử lý ({currentTick}s)";
			if (currentTick == 3 && !backgroundWorker_0.IsBusy)
			{
				backgroundWorker_0.RunWorkerAsync();
			}
			currentTick++;
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
			panelHeader = new System.Windows.Forms.Panel();
			label1 = new System.Windows.Forms.Label();
			picBoxClose = new System.Windows.Forms.PictureBox();
			panelContent = new System.Windows.Forms.Panel();
			lbMsg = new System.Windows.Forms.Label();
			btnRegester = new System.Windows.Forms.Button();
			txtConfirmPassword = new System.Windows.Forms.TextBox();
			label5 = new System.Windows.Forms.Label();
			txtPassword = new System.Windows.Forms.TextBox();
			label4 = new System.Windows.Forms.Label();
			txtPhone = new System.Windows.Forms.TextBox();
			label3 = new System.Windows.Forms.Label();
			txtUsername = new System.Windows.Forms.TextBox();
			label2 = new System.Windows.Forms.Label();
			pictureBox1 = new System.Windows.Forms.PictureBox();
			timer1 = new System.Windows.Forms.Timer(icontainer_0);
			panelHeader.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picBoxClose).BeginInit();
			panelContent.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)pictureBox1).BeginInit();
			SuspendLayout();
			panelHeader.BackColor = System.Drawing.Color.SteelBlue;
			panelHeader.Controls.Add(label1);
			panelHeader.Controls.Add(picBoxClose);
			panelHeader.Dock = System.Windows.Forms.DockStyle.Top;
			panelHeader.Location = new System.Drawing.Point(0, 0);
			panelHeader.Name = "panelHeader";
			panelHeader.Size = new System.Drawing.Size(664, 25);
			panelHeader.TabIndex = 0;
			label1.AutoSize = true;
			label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			label1.ForeColor = System.Drawing.Color.White;
			label1.Location = new System.Drawing.Point(4, 3);
			label1.Name = "label1";
			label1.Size = new System.Drawing.Size(129, 20);
			label1.TabIndex = 1;
			label1.Text = "Đăng ký nhanh";
			picBoxClose.Cursor = System.Windows.Forms.Cursors.Hand;
			picBoxClose.Image = Resources.icons8_close_window_40;
			picBoxClose.Location = new System.Drawing.Point(643, 5);
			picBoxClose.Name = "picBoxClose";
			picBoxClose.Size = new System.Drawing.Size(15, 15);
			picBoxClose.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			picBoxClose.TabIndex = 0;
			picBoxClose.TabStop = false;
			picBoxClose.Click += new System.EventHandler(picBoxClose_Click);
			picBoxClose.MouseLeave += new System.EventHandler(picBoxClose_MouseLeave);
			picBoxClose.MouseHover += new System.EventHandler(picBoxClose_MouseHover);
			panelContent.BackColor = System.Drawing.Color.White;
			panelContent.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			panelContent.Controls.Add(lbMsg);
			panelContent.Controls.Add(btnRegester);
			panelContent.Controls.Add(txtConfirmPassword);
			panelContent.Controls.Add(label5);
			panelContent.Controls.Add(txtPassword);
			panelContent.Controls.Add(label4);
			panelContent.Controls.Add(txtPhone);
			panelContent.Controls.Add(label3);
			panelContent.Controls.Add(txtUsername);
			panelContent.Controls.Add(label2);
			panelContent.Controls.Add(pictureBox1);
			panelContent.Dock = System.Windows.Forms.DockStyle.Fill;
			panelContent.Location = new System.Drawing.Point(0, 25);
			panelContent.Name = "panelContent";
			panelContent.Size = new System.Drawing.Size(664, 471);
			panelContent.TabIndex = 1;
			lbMsg.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbMsg.Location = new System.Drawing.Point(28, 379);
			lbMsg.Name = "lbMsg";
			lbMsg.Size = new System.Drawing.Size(603, 25);
			lbMsg.TabIndex = 5;
			lbMsg.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			btnRegester.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			btnRegester.Location = new System.Drawing.Point(253, 424);
			btnRegester.Name = "btnRegester";
			btnRegester.Size = new System.Drawing.Size(136, 34);
			btnRegester.TabIndex = 5;
			btnRegester.Text = "Đăng ký";
			btnRegester.UseVisualStyleBackColor = true;
			btnRegester.Click += new System.EventHandler(btnRegister_Click);
			txtConfirmPassword.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			txtConfirmPassword.Location = new System.Drawing.Point(177, 346);
			txtConfirmPassword.Name = "txtConfirmPassword";
			txtConfirmPassword.PasswordChar = '*';
			txtConfirmPassword.Size = new System.Drawing.Size(454, 26);
			txtConfirmPassword.TabIndex = 4;
			label5.AutoSize = true;
			label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label5.Location = new System.Drawing.Point(24, 349);
			label5.Name = "label5";
			label5.Size = new System.Drawing.Size(147, 20);
			label5.TabIndex = 1;
			label5.Text = "Xác nhận mật khẩu";
			txtPassword.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			txtPassword.Location = new System.Drawing.Point(177, 295);
			txtPassword.Name = "txtPassword";
			txtPassword.PasswordChar = '*';
			txtPassword.Size = new System.Drawing.Size(454, 26);
			txtPassword.TabIndex = 3;
			label4.AutoSize = true;
			label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label4.Location = new System.Drawing.Point(24, 298);
			label4.Name = "label4";
			label4.Size = new System.Drawing.Size(77, 20);
			label4.TabIndex = 1;
			label4.Text = "Mật Khẩu";
			txtPhone.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			txtPhone.Location = new System.Drawing.Point(177, 243);
			txtPhone.Name = "txtPhone";
			txtPhone.Size = new System.Drawing.Size(454, 26);
			txtPhone.TabIndex = 2;
			label3.AutoSize = true;
			label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label3.Location = new System.Drawing.Point(24, 246);
			label3.Name = "label3";
			label3.Size = new System.Drawing.Size(102, 20);
			label3.TabIndex = 1;
			label3.Text = "Số điện thoại";
			txtUsername.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			txtUsername.Location = new System.Drawing.Point(177, 195);
			txtUsername.Name = "txtUsername";
			txtUsername.Size = new System.Drawing.Size(454, 26);
			txtUsername.TabIndex = 1;
			label2.AutoSize = true;
			label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label2.Location = new System.Drawing.Point(24, 198);
			label2.Name = "label2";
			label2.Size = new System.Drawing.Size(105, 20);
			label2.TabIndex = 1;
			label2.Text = "Tên tài khoản";
			pictureBox1.Image = Resources.help_register;
			pictureBox1.Location = new System.Drawing.Point(3, 3);
			pictureBox1.Name = "pictureBox1";
			pictureBox1.Size = new System.Drawing.Size(658, 143);
			pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			pictureBox1.TabIndex = 0;
			pictureBox1.TabStop = false;
			timer1.Interval = 1000;
			timer1.Tick += new System.EventHandler(timer1_Tick);
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			base.ClientSize = new System.Drawing.Size(664, 496);
			base.Controls.Add(panelContent);
			base.Controls.Add(panelHeader);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Name = "Register";
			base.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			Text = "Register";
			panelHeader.ResumeLayout(false);
			panelHeader.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picBoxClose).EndInit();
			panelContent.ResumeLayout(false);
			panelContent.PerformLayout();
			((System.ComponentModel.ISupportInitialize)pictureBox1).EndInit();
			ResumeLayout(false);
		}

		internal static void pdh5HM42293E0xKSb41()
		{
		}

		internal static void FWQchl4mqtt4ss924T3()
		{
		}

		internal static bool J68wUe4FdGAGxtZVjVr()
		{
			return gTQoux48LprwMmLCPV5 == null;
		}

		internal static void Y75pxIuUfZv5mTeZRXT()
		{
		}
	}
}
