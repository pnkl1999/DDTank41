using Launcher.Popup;
using Launcher.Statics;
using Properties;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Launcher.UserControls
{
    public partial class PaymentMomo : UserControl
    {
		private readonly Main main_0 = Main.Instance;
		public PaymentMomo()
        {
            InitializeComponent();
		}

		private void picBoxReset_Click(object sender, EventArgs e)
        {
            btxtCodeCard.Text = "";
        }

        private void picBoxTopUp_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(btxtCodeCard.Text))
            {
                MessageBox.Show("Mã giao dịch không thể để trống.");
            } else
            {
				new MomoConfirm(this, new string[1]
					{
						btxtCodeCard.Text.ToString(),
					}).ShowDialog();
			}
        }

        private void PaymentMomo_Load(object sender, EventArgs e)
        {
            lblUserMomo.Text += ServerConfig.MOMO_ACCOUNT_NAME;
            lblPhoneMomo.Text += ServerConfig.MOMO_PHONE_NUMBER;
            lblExam.Text += LoginMgr.Username;
        }

        private void PaymentMomo_Enter(object sender, EventArgs e)
        {
			ReloadCash();
		}

		public void ReloadCash()
		{
			SetCursor(Cursors.WaitCursor);
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
					double num = double.Parse(text.Split(':')[1]);
					SetLabelCash(num.ToString("n", CultureInfo.GetCultureInfo("vi-VN")).Replace(",00", ""));
				}
				else
				{
					DDTStaticFunc.AddUpdateLogs("TopUp Refresh Cash", DDTStaticFunc.Host + Resources.CashInfo + " result:" + text);
					SetLabelCash("0");
				}
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 5d " + ex.Message, $"result:{text},  \nerrors:{ex}");
			}
			finally
			{
				main_0.lbCash.Text = labelCash.Text;
			}
			SetCursor(Cursors.Default);
		}

		delegate void SetLabelCashCallback(string text);

		private void SetLabelCash(string text)
		{
			// InvokeRequired required compares the thread ID of the
			// calling thread to the thread ID of the creating thread.
			// If these threads are different, it returns true.
			if (labelCash.InvokeRequired)
			{
				SetLabelCashCallback d = new SetLabelCashCallback(SetLabelCash);
				this.Invoke(d, new object[] { text });
			}
			else
			{
				labelCash.Text = text;
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
	}
}
