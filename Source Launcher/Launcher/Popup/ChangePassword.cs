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
	public class ChangePassword : Form
	{
		private BackgroundWorker backgroundWorker_0;

		private bool bool_0;

		private int int_0 = 1;

		private IContainer icontainer_0;

		private Panel panelTitle;

		private PictureBox picBoxClose;

		private Label label1;

		private Label label2;

		private TextBox txtOldPass;

		private Label label3;

		private TextBox txtNewPass;

		private Label label4;

		private TextBox txtConfirmPass;

		private Button btnAccept;

		private Button btnCancel;

		private Timer timer_0;

		private Label lbMsg;

		internal static ChangePassword dh4TuUv1xECggs55rW3;

		public ChangePassword()
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
			timer_0.Stop();
			btnAccept.Enabled = true;
			btnAccept.Text = "Xác nhận";
		}

		private void backgroundWorker_0_DoWork(object sender, DoWorkEventArgs e)
		{
			string text = txtNewPass.Text;
			string value = Convert.ToBase64String(ControlMgr.CryptData(LoginMgr.Username + "|" + LoginMgr.Password + "|" + text + "|" + Util.MD5(LoginMgr.Username + LoginMgr.Password + Resources.PublicKey)));
			NameValueCollection param = new NameValueCollection { { "token", value } };
			string text2 = ControlMgr.Post(DDTStaticFunc.Host + Resources.ChangePassword, param);
			try
			{
				string[] array = text2.Split('|');
				if (array.Length == 2)
				{
					if (array[0] == "1")
					{
						SetColor(Color.Green);
						bool_0 = true;
					}
					SetText(array[1]);
				}
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception BackWorkerRequestChangePasswordExchange_DoWork " + ex.Message, $"result:{text2},  \nerrors:{ex}");
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

		private void method_0()
		{
			Cursor = Cursors.Default;
			timer_0.Stop();
			Hide();
			if (bool_0)
			{
				Main.Instance.LogOut();
			}
		}

		private void picBoxClose_Click(object sender, EventArgs e)
		{
			method_0();
		}

		private void btnCancel_Click(object sender, EventArgs e)
		{
			method_0();
		}

		private void btnAccept_Click(object sender, EventArgs e)
		{
			int_0 = 1;
			lbMsg.Visible = true;
			lbMsg.Text = "";
			lbMsg.ForeColor = Color.Red;
			if (!string.IsNullOrEmpty(txtOldPass.Text))
			{
				string text = Util.MD5(txtOldPass.Text).ToUpper();
				if (text != Util.MD5(LoginMgr.Password).ToUpper())
				{
					lbMsg.Text = "Mật khẩu cũ không chính xác!";
				}
				else if (string.IsNullOrEmpty(txtNewPass.Text))
				{
					lbMsg.Text = "Mật khẩu mới không được để trống!";
				}
				else if (!(text == Util.MD5(txtNewPass.Text).ToUpper()))
				{
					if (string.IsNullOrEmpty(txtConfirmPass.Text))
					{
						lbMsg.Text = "Xác nhận mới không được để trống!";
					}
					else if (txtNewPass.Text == txtConfirmPass.Text)
					{
						Cursor = Cursors.WaitCursor;
						btnAccept.Enabled = false;
						timer_0.Start();
					}
					else
					{
						lbMsg.Text = "Mật khẩu mới và Mật khẩu nhập lại không trùng khớp.";
					}
				}
				else
				{
					lbMsg.Text = "Mật khẩu cũ và mới không được trùng nhau!";
				}
			}
			else
			{
				lbMsg.Text = "Mật khẩu cũ không được để trống!";
			}
		}

		private void ChangePassword_Load(object sender, EventArgs e)
		{
			lbMsg.Visible = false;
		}

		private void EonAjnvuDy(object sender, EventArgs e)
		{
			btnAccept.Text = $"Đang xử lý ({int_0}s)";
			if (int_0 == 3 && !backgroundWorker_0.IsBusy)
			{
				backgroundWorker_0.RunWorkerAsync();
			}
			int_0++;
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
			panelTitle = new System.Windows.Forms.Panel();
			label1 = new System.Windows.Forms.Label();
			picBoxClose = new System.Windows.Forms.PictureBox();
			label2 = new System.Windows.Forms.Label();
			txtOldPass = new System.Windows.Forms.TextBox();
			label3 = new System.Windows.Forms.Label();
			txtNewPass = new System.Windows.Forms.TextBox();
			label4 = new System.Windows.Forms.Label();
			txtConfirmPass = new System.Windows.Forms.TextBox();
			btnAccept = new System.Windows.Forms.Button();
			btnCancel = new System.Windows.Forms.Button();
			timer_0 = new System.Windows.Forms.Timer(icontainer_0);
			lbMsg = new System.Windows.Forms.Label();
			panelTitle.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picBoxClose).BeginInit();
			SuspendLayout();
			panelTitle.BackColor = System.Drawing.Color.SteelBlue;
			panelTitle.Controls.Add(label1);
			panelTitle.Controls.Add(picBoxClose);
			panelTitle.Dock = System.Windows.Forms.DockStyle.Top;
			panelTitle.Location = new System.Drawing.Point(0, 0);
			panelTitle.Name = "panelTitle";
			panelTitle.Size = new System.Drawing.Size(359, 30);
			panelTitle.TabIndex = 0;
			label1.AutoSize = true;
			label1.ForeColor = System.Drawing.Color.White;
			label1.Location = new System.Drawing.Point(13, 8);
			label1.Name = "label1";
			label1.Size = new System.Drawing.Size(70, 13);
			label1.TabIndex = 1;
			label1.Text = "Đổi mật khẩu";
			picBoxClose.Image = Resources.icons8_close_window_40;
			picBoxClose.Location = new System.Drawing.Point(337, 8);
			picBoxClose.Name = "picBoxClose";
			picBoxClose.Size = new System.Drawing.Size(15, 15);
			picBoxClose.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			picBoxClose.TabIndex = 0;
			picBoxClose.TabStop = false;
			picBoxClose.Click += new System.EventHandler(picBoxClose_Click);
			label2.AutoSize = true;
			label2.Location = new System.Drawing.Point(19, 41);
			label2.Name = "label2";
			label2.Size = new System.Drawing.Size(70, 13);
			label2.TabIndex = 1;
			label2.Text = "Mật khẩu cũ:";
			txtOldPass.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			txtOldPass.Location = new System.Drawing.Point(22, 59);
			txtOldPass.Name = "txtOldPass";
			txtOldPass.PasswordChar = '*';
			txtOldPass.Size = new System.Drawing.Size(325, 22);
			txtOldPass.TabIndex = 1;
			label3.AutoSize = true;
			label3.Location = new System.Drawing.Point(19, 88);
			label3.Name = "label3";
			label3.Size = new System.Drawing.Size(102, 13);
			label3.TabIndex = 1;
			label3.Text = "Nhập mật khẩu mới:";
			txtNewPass.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			txtNewPass.Location = new System.Drawing.Point(20, 105);
			txtNewPass.Name = "txtNewPass";
			txtNewPass.PasswordChar = '*';
			txtNewPass.Size = new System.Drawing.Size(327, 22);
			txtNewPass.TabIndex = 2;
			label4.AutoSize = true;
			label4.Location = new System.Drawing.Point(17, 134);
			label4.Name = "label4";
			label4.Size = new System.Drawing.Size(115, 13);
			label4.TabIndex = 1;
			label4.Text = "Nhập lại mật khẩu mới:";
			txtConfirmPass.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			txtConfirmPass.Location = new System.Drawing.Point(19, 152);
			txtConfirmPass.Name = "txtConfirmPass";
			txtConfirmPass.PasswordChar = '*';
			txtConfirmPass.Size = new System.Drawing.Size(328, 22);
			txtConfirmPass.TabIndex = 3;
			btnAccept.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			btnAccept.Location = new System.Drawing.Point(51, 207);
			btnAccept.Name = "btnAccept";
			btnAccept.Size = new System.Drawing.Size(123, 25);
			btnAccept.TabIndex = 4;
			btnAccept.Text = "Xác nhận";
			btnAccept.UseVisualStyleBackColor = true;
			btnAccept.Click += new System.EventHandler(btnAccept_Click);
			btnCancel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			btnCancel.Location = new System.Drawing.Point(189, 207);
			btnCancel.Name = "btnCancel";
			btnCancel.Size = new System.Drawing.Size(99, 25);
			btnCancel.TabIndex = 33;
			btnCancel.Text = "Đóng";
			btnCancel.UseVisualStyleBackColor = true;
			btnCancel.Click += new System.EventHandler(btnCancel_Click);
			timer_0.Interval = 1000;
			timer_0.Tick += new System.EventHandler(EonAjnvuDy);
			lbMsg.Location = new System.Drawing.Point(20, 177);
			lbMsg.Name = "lbMsg";
			lbMsg.Size = new System.Drawing.Size(327, 25);
			lbMsg.TabIndex = 4;
			lbMsg.Text = "error msg";
			lbMsg.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			base.ClientSize = new System.Drawing.Size(359, 240);
			base.Controls.Add(lbMsg);
			base.Controls.Add(btnCancel);
			base.Controls.Add(btnAccept);
			base.Controls.Add(txtConfirmPass);
			base.Controls.Add(label4);
			base.Controls.Add(txtNewPass);
			base.Controls.Add(label3);
			base.Controls.Add(txtOldPass);
			base.Controls.Add(label2);
			base.Controls.Add(panelTitle);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Name = "ChangePassword";
			base.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			Text = "ChangePassword";
			base.Load += new System.EventHandler(ChangePassword_Load);
			panelTitle.ResumeLayout(false);
			panelTitle.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picBoxClose).EndInit();
			ResumeLayout(false);
			PerformLayout();
		}

		internal static void q4S8UrvwyHXEFDvwvmv()
		{
		}

		internal static void CxQgkpv31RMgYQfAl0i()
		{
		}

		internal static bool TV7m1VvJt3dL1x3Rwbt()
		{
			return dh4TuUv1xECggs55rW3 == null;
		}

		internal static void CXPubJAFpdntoowtuEd()
		{
		}
	}
}
