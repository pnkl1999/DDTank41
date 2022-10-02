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
	public class ForgotPassword : Form
	{
        private BackgroundWorker backgroundWorker_0;
        private IContainer icontainer_0;

		private Panel panel2;

		private PictureBox picBoxClose;
        private Button btnForgotPass;
        private TextBox txtPhone;
        private Label label3;
        private TextBox txtUsername;
        private Label label2;
        private Panel panelTutorial;
        private Label label1;
        private Panel panelHeader;
        private Label label4;
        private Label label6;
        private Label label5;
        private Label lbMsg;
        private Timer timer1;
        private IContainer components;
        private static ForgotPassword DkYOGfAPn2CC6ZgjSws;
        private int currentTick;

        public ForgotPassword()
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

		protected override void Dispose(bool disposing)
		{
			if (disposing && icontainer_0 != null)
			{
				icontainer_0.Dispose();
			}
			base.Dispose(disposing);
		}

        private void backgroundWorker_0_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
        }

        private void backgroundWorker_0_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            timer1.Stop();
            btnForgotPass.Enabled = true;
            btnForgotPass.Text = "Xác nhận";
        }

        private void backgroundWorker_0_DoWork(object sender, DoWorkEventArgs e)
        {
            string text = txtUsername.Text;
            string text3 = txtPhone.Text;
            string localIPAddress = DDTStaticFunc.GetLocalIPAddress();
            NameValueCollection param = new NameValueCollection
            {
                { "u", text },
                { "phone", text3 },
                { "ip", localIPAddress }
            };
            string text4 = ControlMgr.Post(DDTStaticFunc.Host + Resources.ForgotPass, param);
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
                } else
                {
                    SetText(text4);
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

        private void InitializeComponent()
		{
            this.components = new System.ComponentModel.Container();
            this.panel2 = new System.Windows.Forms.Panel();
            this.panelHeader = new System.Windows.Forms.Panel();
            this.label4 = new System.Windows.Forms.Label();
            this.picBoxClose = new System.Windows.Forms.PictureBox();
            this.panelTutorial = new System.Windows.Forms.Panel();
            this.label6 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.txtPhone = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtUsername = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.btnForgotPass = new System.Windows.Forms.Button();
            this.lbMsg = new System.Windows.Forms.Label();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.panel2.SuspendLayout();
            this.panelHeader.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxClose)).BeginInit();
            this.panelTutorial.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel2
            // 
            this.panel2.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.panel2.Controls.Add(this.lbMsg);
            this.panel2.Controls.Add(this.panelHeader);
            this.panel2.Controls.Add(this.panelTutorial);
            this.panel2.Controls.Add(this.txtPhone);
            this.panel2.Controls.Add(this.label3);
            this.panel2.Controls.Add(this.txtUsername);
            this.panel2.Controls.Add(this.label2);
            this.panel2.Controls.Add(this.btnForgotPass);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(690, 320);
            this.panel2.TabIndex = 1;
            // 
            // panelHeader
            // 
            this.panelHeader.BackColor = System.Drawing.Color.SteelBlue;
            this.panelHeader.Controls.Add(this.label4);
            this.panelHeader.Controls.Add(this.picBoxClose);
            this.panelHeader.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelHeader.Location = new System.Drawing.Point(0, 0);
            this.panelHeader.Name = "panelHeader";
            this.panelHeader.Size = new System.Drawing.Size(690, 28);
            this.panelHeader.TabIndex = 16;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.White;
            this.label4.Location = new System.Drawing.Point(4, 3);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(131, 20);
            this.label4.TabIndex = 1;
            this.label4.Text = "Quên mật khẩu";
            // 
            // picBoxClose
            // 
            this.picBoxClose.Cursor = System.Windows.Forms.Cursors.Hand;
            this.picBoxClose.Image = global::Properties.Resources.icons8_close_window_40;
            this.picBoxClose.Location = new System.Drawing.Point(672, 3);
            this.picBoxClose.Name = "picBoxClose";
            this.picBoxClose.Size = new System.Drawing.Size(15, 15);
            this.picBoxClose.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picBoxClose.TabIndex = 0;
            this.picBoxClose.TabStop = false;
            this.picBoxClose.Click += new System.EventHandler(this.picBoxClose_Click);
            this.picBoxClose.MouseLeave += new System.EventHandler(this.picBoxClose_MouseLeave);
            this.picBoxClose.MouseHover += new System.EventHandler(this.picBoxClose_MouseHover);
            // 
            // panelTutorial
            // 
            this.panelTutorial.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(218)))), ((int)(((byte)(242)))), ((int)(((byte)(228)))));
            this.panelTutorial.Controls.Add(this.label6);
            this.panelTutorial.Controls.Add(this.label5);
            this.panelTutorial.Controls.Add(this.label1);
            this.panelTutorial.Location = new System.Drawing.Point(12, 34);
            this.panelTutorial.Name = "panelTutorial";
            this.panelTutorial.Size = new System.Drawing.Size(666, 112);
            this.panelTutorial.TabIndex = 15;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F);
            this.label6.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(39)))), ((int)(((byte)(174)))), ((int)(((byte)(96)))));
            this.label6.Location = new System.Drawing.Point(10, 79);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(389, 18);
            this.label6.TabIndex = 2;
            this.label6.Text = "● Sau khi thành công mật khẩu sẽ được đổi thành 123456.";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F);
            this.label5.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(39)))), ((int)(((byte)(174)))), ((int)(((byte)(96)))));
            this.label5.Location = new System.Drawing.Point(10, 49);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(304, 18);
            this.label5.TabIndex = 1;
            this.label5.Text = "● Nhập sai quá 3 lần sẽ khóa tạm thời 5 phút.";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 15F);
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(39)))), ((int)(((byte)(174)))), ((int)(((byte)(96)))));
            this.label1.Location = new System.Drawing.Point(10, 10);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(128, 25);
            this.label1.TabIndex = 0;
            this.label1.Text = "✐ Hướng dẫn";
            // 
            // txtPhone
            // 
            this.txtPhone.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtPhone.Location = new System.Drawing.Point(198, 216);
            this.txtPhone.Name = "txtPhone";
            this.txtPhone.Size = new System.Drawing.Size(454, 26);
            this.txtPhone.TabIndex = 14;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(45, 219);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(102, 20);
            this.label3.TabIndex = 11;
            this.label3.Text = "Số điện thoại";
            // 
            // txtUsername
            // 
            this.txtUsername.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtUsername.Location = new System.Drawing.Point(198, 168);
            this.txtUsername.Name = "txtUsername";
            this.txtUsername.Size = new System.Drawing.Size(454, 26);
            this.txtUsername.TabIndex = 12;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(45, 171);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(105, 20);
            this.label2.TabIndex = 13;
            this.label2.Text = "Tên tài khoản";
            // 
            // btnForgotPass
            // 
            this.btnForgotPass.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnForgotPass.Location = new System.Drawing.Point(268, 274);
            this.btnForgotPass.Name = "btnForgotPass";
            this.btnForgotPass.Size = new System.Drawing.Size(136, 34);
            this.btnForgotPass.TabIndex = 10;
            this.btnForgotPass.Text = "Lấy mật khẩu";
            this.btnForgotPass.UseVisualStyleBackColor = true;
            this.btnForgotPass.Click += new System.EventHandler(this.btnForgotPass_Click);
            // 
            // lbMsg
            // 
            this.lbMsg.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbMsg.Location = new System.Drawing.Point(46, 246);
            this.lbMsg.Name = "lbMsg";
            this.lbMsg.Size = new System.Drawing.Size(603, 25);
            this.lbMsg.TabIndex = 17;
            this.lbMsg.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // timer1
            // 
            this.timer1.Interval = 1000;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // ForgotPassword
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(690, 320);
            this.Controls.Add(this.panel2);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "ForgotPassword";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "ForgotPassword";
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panelHeader.ResumeLayout(false);
            this.panelHeader.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxClose)).EndInit();
            this.panelTutorial.ResumeLayout(false);
            this.panelTutorial.PerformLayout();
            this.ResumeLayout(false);

		}

		internal static void Mh34AnApwkG7afP0DWP()
		{
		}

		internal static void OuPLVOAflReaosOuRtO()
		{
		}

		internal static bool PWmFeGA2YSIXrsOockY()
		{
			return DkYOGfAPn2CC6ZgjSws == null;
		}

        private void btnForgotPass_Click(object sender, EventArgs e)
        {
            currentTick = 1;
            lbMsg.Visible = true;
            lbMsg.Text = "";
            lbMsg.ForeColor = Color.Red;
            if (string.IsNullOrEmpty(txtUsername.Text))
            {
                lbMsg.Text = "Tài khoản không được để trống!";
            }
            else if (string.IsNullOrEmpty(txtPhone.Text))
            {
                lbMsg.Text = "Số DT không được để trống!";
            }
            else
            {
                Cursor = Cursors.WaitCursor;
                btnForgotPass.Enabled = false;
                timer1.Start();
            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            btnForgotPass.Text = $"Đang xử lý ({currentTick}s)";
            if (currentTick == 3 && !backgroundWorker_0.IsBusy)
            {
                backgroundWorker_0.RunWorkerAsync();
            }
            currentTick++;
        }
    }
}
