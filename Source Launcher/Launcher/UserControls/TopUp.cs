using System;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Windows.Forms;
using Bunifu.UI.WinForms;
using Launcher.Popup;
using Launcher.Properties;
using Launcher.Statics;
using Properties;

namespace Launcher.UserControls
{
	public class TopUp : UserControl
	{
		private readonly Main main_0 = Main.Instance;

		private int cardType = 1;

		private IContainer icontainer_0;

		private Label label1;

		private PictureBox picBoxReset;

		private PictureBox picBoxTopUp;

		private Panel panel1;

		private Label labelCash;

		private Label label4;

		private Label label2;

		private Label label10;

		private Label lbNote;

		private RadioButton radioButton1;

		private RadioButton radioButton2;

		private RadioButton radioButton3;

		private RadioButton radioButton4;

		private RadioButton radioButton5;

		private RadioButton radioButton6;

		private RadioButton radioButton7;

		private RadioButton radioButton8;

		private RadioButton radioButton9;

		private RadioButton radioButton10;

		private Label lxbcuVnqkS;

		private BunifuTextBox btxtSerialCard;

		private BunifuTextBox btxtCodeCard;

		private PictureBox picSerialCard;

		private PictureBox picCodeCard;

		private Panel panelCardTypes;

		private Panel panelZing;

		private PictureBox picSelectZing;

		private Label UhGclFcnaf;

		private PictureBox picZing;

		private Panel panelGate;

		private PictureBox picSelectGate;

		private Label lbGate;

		private PictureBox picGate;

		private Panel panelVcoin;

		private PictureBox picSelectVcoin;

		private Label lbVcoin;

		private PictureBox picVcoin;

		private Panel panelVina;

		private PictureBox picSelectVina;

		private Label lbVina;

		private PictureBox picVina;

		private Panel panelMobi;

		private PictureBox picSelectMobi;

		private Label GxncioFdiP;

		private PictureBox picMobi;

		private Panel panelViettel;

		private Label lbViettel;

		private PictureBox picSelectViettel;

		private PictureBox picViettel;

		private Label label3;

		internal static TopUp W43M4G033fRNWZHFZrJ;

		public TopUp()
		{
			InitializeComponent();
			btxtCodeCard.Height = (btxtSerialCard.Height = main_0.FixScaling(32));
			picCodeCard.Height = (picSerialCard.Height = btxtCodeCard.Height);
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

		private void TopUp_Load(object sender, EventArgs e)
		{
		}

		private void TopUp_Enter(object sender, EventArgs e)
		{
			ReloadCash();
		}

		private void picBoxReset_Click(object sender, EventArgs e)
		{
			btxtCodeCard.Text = "";
			btxtSerialCard.Text = "";
			cardType = 1;
			string text = "Viettel";
			foreach (object control in panelCardTypes.Controls)
			{
				if (!(control is Panel))
				{
					continue;
				}
				foreach (object control2 in (control as Panel).Controls)
				{
					if (control2 is PictureBox && (control2 as PictureBox).Name.IndexOf("picSelect") != -1)
					{
						(control2 as PictureBox).Visible = false;
					}
				}
				if ((control as Panel).Name.IndexOf(text) == -1)
				{
					continue;
				}
				foreach (object control3 in (control as Panel).Controls)
				{
					if (control3 is PictureBox && (control3 as PictureBox).Name == "picSelect" + text)
					{
						(control3 as PictureBox).Visible = true;
					}
				}
			}
			RadioButton radioButton = base.Controls.OfType<RadioButton>().FirstOrDefault((RadioButton n) => n.Checked);
			if (radioButton != null)
			{
				radioButton.Checked = false;
			}
		}

		private void picBoxTopUp_Click(object sender, EventArgs e)
		{
			RadioButton radioButton = base.Controls.OfType<RadioButton>().FirstOrDefault((RadioButton n) => n.Checked);
			if (cardType == -1)
			{
				MessageBox.Show("Bạn chưa chọn loại thẻ cào.");
			}
			else if (string.IsNullOrEmpty(btxtCodeCard.Text))
			{
				MessageBox.Show("Mã thẻ cào không thể để trống.");
			}
			else if (string.IsNullOrEmpty(btxtSerialCard.Text))
			{
				MessageBox.Show("Serial thẻ cào không thể để trống.");
			}
			else if (radioButton != null)
			{
				if (radioButton != null)
				{
					string text = radioButton.Text.Replace(" VND", "");
					new TopUpConfirm(this, new string[4]
					{
						cardType.ToString(),
						btxtCodeCard.Text,
						btxtSerialCard.Text,
						text.Replace(".", "")
					}).ShowDialog();
				}
			}
			else
			{
				MessageBox.Show("Bạn chưa chọn mệnh giá thẻ cào.");
			}
		}

		private void picBoxTopUp_MouseHover(object sender, EventArgs e)
		{
			picBoxTopUp.Image = Resources.ok_Over;
		}

		private void picBoxTopUp_MouseLeave(object sender, EventArgs e)
		{
			picBoxTopUp.Image = Resources.ok;
		}

		private void picBoxReset_MouseHover(object sender, EventArgs e)
		{
			picBoxReset.Image = Resources.Reset_Over;
		}

		private void picBoxReset_MouseLeave(object sender, EventArgs e)
		{
			picBoxReset.Image = Resources.Reset;
		}

		private void picViettel_Click(object sender, EventArgs e)
		{
			string text = "null";
			if (sender is PictureBox)
			{
				text = (sender as PictureBox).Name;
			}
			if (sender is Label)
			{
				text = (sender as Label).Name;
			}
			if (sender is Panel)
			{
				text = (sender as Panel).Name;
			}
			text = text.Replace("pic", "").Replace("lb", "").Replace("panel", "");
			foreach (object control in panelCardTypes.Controls)
			{
				if (!(control is Panel))
				{
					continue;
				}
				foreach (object control2 in (control as Panel).Controls)
				{
					if (control2 is PictureBox && (control2 as PictureBox).Name.IndexOf("picSelect") != -1)
					{
						(control2 as PictureBox).Visible = false;
					}
				}
				if ((control as Panel).Name.IndexOf(text) == -1)
				{
					continue;
				}
				foreach (object control3 in (control as Panel).Controls)
				{
					if (control3 is PictureBox && (control3 as PictureBox).Name == "picSelect" + text)
					{
						(control3 as PictureBox).Visible = true;
						switch (text)
						{
						case "Mobi":
							cardType = 2;
							break;
						case "Zing":
							cardType = 6;
							break;
						case "Gate":
							cardType = 5;
							break;
						case "Vcoin":
							cardType = 4;
							break;
						case "Vina":
							cardType = 3;
							break;
						case "Viettel":
							cardType = 1;
							break;
						}
					}
				}
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Launcher.UserControls.TopUp));
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties2 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties3 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties4 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties5 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties6 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties7 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties8 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			label1 = new System.Windows.Forms.Label();
			picBoxReset = new System.Windows.Forms.PictureBox();
			picBoxTopUp = new System.Windows.Forms.PictureBox();
			panel1 = new System.Windows.Forms.Panel();
			label3 = new System.Windows.Forms.Label();
			labelCash = new System.Windows.Forms.Label();
			label4 = new System.Windows.Forms.Label();
			label2 = new System.Windows.Forms.Label();
			label10 = new System.Windows.Forms.Label();
			lbNote = new System.Windows.Forms.Label();
			radioButton1 = new System.Windows.Forms.RadioButton();
			radioButton2 = new System.Windows.Forms.RadioButton();
			radioButton3 = new System.Windows.Forms.RadioButton();
			radioButton4 = new System.Windows.Forms.RadioButton();
			radioButton5 = new System.Windows.Forms.RadioButton();
			radioButton6 = new System.Windows.Forms.RadioButton();
			radioButton7 = new System.Windows.Forms.RadioButton();
			radioButton8 = new System.Windows.Forms.RadioButton();
			radioButton9 = new System.Windows.Forms.RadioButton();
			radioButton10 = new System.Windows.Forms.RadioButton();
			lxbcuVnqkS = new System.Windows.Forms.Label();
			btxtSerialCard = new Bunifu.UI.WinForms.BunifuTextBox();
			btxtCodeCard = new Bunifu.UI.WinForms.BunifuTextBox();
			picSerialCard = new System.Windows.Forms.PictureBox();
			picCodeCard = new System.Windows.Forms.PictureBox();
			panelCardTypes = new System.Windows.Forms.Panel();
			panelZing = new System.Windows.Forms.Panel();
			picSelectZing = new System.Windows.Forms.PictureBox();
			UhGclFcnaf = new System.Windows.Forms.Label();
			picZing = new System.Windows.Forms.PictureBox();
			panelGate = new System.Windows.Forms.Panel();
			picSelectGate = new System.Windows.Forms.PictureBox();
			lbGate = new System.Windows.Forms.Label();
			picGate = new System.Windows.Forms.PictureBox();
			panelVcoin = new System.Windows.Forms.Panel();
			picSelectVcoin = new System.Windows.Forms.PictureBox();
			lbVcoin = new System.Windows.Forms.Label();
			picVcoin = new System.Windows.Forms.PictureBox();
			panelVina = new System.Windows.Forms.Panel();
			picSelectVina = new System.Windows.Forms.PictureBox();
			lbVina = new System.Windows.Forms.Label();
			picVina = new System.Windows.Forms.PictureBox();
			panelMobi = new System.Windows.Forms.Panel();
			picSelectMobi = new System.Windows.Forms.PictureBox();
			GxncioFdiP = new System.Windows.Forms.Label();
			picMobi = new System.Windows.Forms.PictureBox();
			panelViettel = new System.Windows.Forms.Panel();
			lbViettel = new System.Windows.Forms.Label();
			picSelectViettel = new System.Windows.Forms.PictureBox();
			picViettel = new System.Windows.Forms.PictureBox();
			((System.ComponentModel.ISupportInitialize)picBoxReset).BeginInit();
			((System.ComponentModel.ISupportInitialize)picBoxTopUp).BeginInit();
			panel1.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picSerialCard).BeginInit();
			((System.ComponentModel.ISupportInitialize)picCodeCard).BeginInit();
			panelCardTypes.SuspendLayout();
			panelZing.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picSelectZing).BeginInit();
			((System.ComponentModel.ISupportInitialize)picZing).BeginInit();
			panelGate.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picSelectGate).BeginInit();
			((System.ComponentModel.ISupportInitialize)picGate).BeginInit();
			panelVcoin.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picSelectVcoin).BeginInit();
			((System.ComponentModel.ISupportInitialize)picVcoin).BeginInit();
			panelVina.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picSelectVina).BeginInit();
			((System.ComponentModel.ISupportInitialize)picVina).BeginInit();
			panelMobi.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picSelectMobi).BeginInit();
			((System.ComponentModel.ISupportInitialize)picMobi).BeginInit();
			panelViettel.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picSelectViettel).BeginInit();
			((System.ComponentModel.ISupportInitialize)picViettel).BeginInit();
			SuspendLayout();
			label1.AutoSize = true;
			label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 20.25f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label1.Location = new System.Drawing.Point(296, 20);
			label1.Name = "label1";
			label1.Size = new System.Drawing.Size(371, 31);
			label1.TabIndex = 0;
			label1.Text = "NẠP CASH VÀO TÀI KHOẢN";
			picBoxReset.Cursor = System.Windows.Forms.Cursors.Hand;
			picBoxReset.Image = Resources.Reset;
			picBoxReset.Location = new System.Drawing.Point(510, 524);
			picBoxReset.Name = "picBoxReset";
			picBoxReset.Size = new System.Drawing.Size(100, 40);
			picBoxReset.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picBoxReset.TabIndex = 3;
			picBoxReset.TabStop = false;
			picBoxReset.Click += new System.EventHandler(picBoxReset_Click);
			picBoxReset.MouseLeave += new System.EventHandler(picBoxReset_MouseLeave);
			picBoxReset.MouseHover += new System.EventHandler(picBoxReset_MouseHover);
			picBoxTopUp.Cursor = System.Windows.Forms.Cursors.Hand;
			picBoxTopUp.Image = Resources.ok;
			picBoxTopUp.Location = new System.Drawing.Point(366, 524);
			picBoxTopUp.Name = "picBoxTopUp";
			picBoxTopUp.Size = new System.Drawing.Size(135, 40);
			picBoxTopUp.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picBoxTopUp.TabIndex = 4;
			picBoxTopUp.TabStop = false;
			picBoxTopUp.Click += new System.EventHandler(picBoxTopUp_Click);
			picBoxTopUp.MouseLeave += new System.EventHandler(picBoxTopUp_MouseLeave);
			picBoxTopUp.MouseHover += new System.EventHandler(picBoxTopUp_MouseHover);
			panel1.Anchor = System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
			panel1.BackColor = System.Drawing.Color.WhiteSmoke;
			panel1.Controls.Add(label3);
			panel1.Controls.Add(labelCash);
			panel1.Controls.Add(label4);
			panel1.Controls.Add(label2);
			panel1.Location = new System.Drawing.Point(0, 85);
			panel1.Name = "panel1";
			panel1.Size = new System.Drawing.Size(1000, 40);
			panel1.TabIndex = 5;
			label3.AutoSize = true;
			label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label3.ForeColor = System.Drawing.Color.DarkRed;
			label3.Location = new System.Drawing.Point(277, 13);
			label3.Name = "label3";
			label3.Size = new System.Drawing.Size(468, 16);
			label3.TabIndex = 1;
			label3.Text = "Nạp bằng MoMo,  Chuyển khoản vào Hỗ trợ ->Live Chat để biết thêm thông tin.";
			labelCash.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			labelCash.ForeColor = System.Drawing.Color.DarkGreen;
			labelCash.Location = new System.Drawing.Point(102, 12);
			labelCash.Name = "labelCash";
			labelCash.Size = new System.Drawing.Size(86, 16);
			labelCash.TabIndex = 0;
			labelCash.Text = "99.999.999";
			labelCash.TextAlign = System.Drawing.ContentAlignment.TopRight;
			label4.AutoSize = true;
			label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			label4.ForeColor = System.Drawing.Color.Red;
			label4.Location = new System.Drawing.Point(187, 12);
			label4.Name = "label4";
			label4.Size = new System.Drawing.Size(43, 16);
			label4.TabIndex = 0;
			label4.Text = "Cash";
			label2.AutoSize = true;
			label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			label2.Location = new System.Drawing.Point(15, 12);
			label2.Name = "label2";
			label2.Size = new System.Drawing.Size(86, 16);
			label2.TabIndex = 0;
			label2.Text = "Hiện tại có:";
			label10.AutoSize = true;
			label10.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label10.Location = new System.Drawing.Point(43, 382);
			label10.Name = "label10";
			label10.Size = new System.Drawing.Size(100, 18);
			label10.TabIndex = 7;
			label10.Text = "Mệnh giá thẻ: ";
			lbNote.AutoSize = true;
			lbNote.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbNote.ForeColor = System.Drawing.Color.Red;
			lbNote.Location = new System.Drawing.Point(238, 496);
			lbNote.Name = "lbNote";
			lbNote.Size = new System.Drawing.Size(500, 16);
			lbNote.TabIndex = 8;
			lbNote.Text = "Lưu ý: Bạn phải chọn chính xác đúng mệnh giá, nếu sai sẽ mất thẻ và không có cash";
			radioButton1.AutoSize = true;
			radioButton1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton1.Location = new System.Drawing.Point(65, 412);
			radioButton1.Name = "radioButton1";
			radioButton1.Size = new System.Drawing.Size(90, 19);
			radioButton1.TabIndex = 9;
			radioButton1.Text = "10.000 VND";
			radioButton1.UseVisualStyleBackColor = true;
			radioButton2.AutoSize = true;
			radioButton2.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton2.Location = new System.Drawing.Point(260, 412);
			radioButton2.Name = "radioButton2";
			radioButton2.Size = new System.Drawing.Size(90, 19);
			radioButton2.TabIndex = 9;
			radioButton2.Text = "20.000 VND";
			radioButton2.UseVisualStyleBackColor = true;
			radioButton3.AutoSize = true;
			radioButton3.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton3.Location = new System.Drawing.Point(455, 412);
			radioButton3.Name = "radioButton3";
			radioButton3.Size = new System.Drawing.Size(90, 19);
			radioButton3.TabIndex = 9;
			radioButton3.Text = "30.000 VND";
			radioButton3.UseVisualStyleBackColor = true;
			radioButton4.AutoSize = true;
			radioButton4.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton4.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton4.Location = new System.Drawing.Point(650, 412);
			radioButton4.Name = "radioButton4";
			radioButton4.Size = new System.Drawing.Size(90, 19);
			radioButton4.TabIndex = 9;
			radioButton4.Text = "50.000 VND";
			radioButton4.UseVisualStyleBackColor = true;
			radioButton5.AutoSize = true;
			radioButton5.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton5.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton5.Location = new System.Drawing.Point(845, 412);
			radioButton5.Name = "radioButton5";
			radioButton5.Size = new System.Drawing.Size(97, 19);
			radioButton5.TabIndex = 9;
			radioButton5.Text = "100.000 VND";
			radioButton5.UseVisualStyleBackColor = true;
			radioButton6.AutoSize = true;
			radioButton6.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton6.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton6.Location = new System.Drawing.Point(65, 452);
			radioButton6.Name = "radioButton6";
			radioButton6.Size = new System.Drawing.Size(97, 19);
			radioButton6.TabIndex = 9;
			radioButton6.Text = "200.000 VND";
			radioButton6.UseVisualStyleBackColor = true;
			radioButton7.AutoSize = true;
			radioButton7.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton7.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton7.Location = new System.Drawing.Point(260, 452);
			radioButton7.Name = "radioButton7";
			radioButton7.Size = new System.Drawing.Size(97, 19);
			radioButton7.TabIndex = 9;
			radioButton7.Text = "300.000 VND";
			radioButton7.UseVisualStyleBackColor = true;
			radioButton8.AutoSize = true;
			radioButton8.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton8.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton8.Location = new System.Drawing.Point(455, 452);
			radioButton8.Name = "radioButton8";
			radioButton8.Size = new System.Drawing.Size(97, 19);
			radioButton8.TabIndex = 9;
			radioButton8.Text = "500.000 VND";
			radioButton8.UseVisualStyleBackColor = true;
			radioButton9.AutoSize = true;
			radioButton9.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton9.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton9.Location = new System.Drawing.Point(650, 452);
			radioButton9.Name = "radioButton9";
			radioButton9.Size = new System.Drawing.Size(107, 19);
			radioButton9.TabIndex = 9;
			radioButton9.Text = "1.000.000 VND";
			radioButton9.UseVisualStyleBackColor = true;
			radioButton10.AutoSize = true;
			radioButton10.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
			radioButton10.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			radioButton10.Location = new System.Drawing.Point(845, 452);
			radioButton10.Name = "radioButton10";
			radioButton10.Size = new System.Drawing.Size(107, 19);
			radioButton10.TabIndex = 9;
			radioButton10.Text = "2.000.000 VND";
			radioButton10.UseVisualStyleBackColor = true;
			lxbcuVnqkS.AutoSize = true;
			lxbcuVnqkS.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lxbcuVnqkS.Location = new System.Drawing.Point(43, 140);
			lxbcuVnqkS.Name = "label12";
			lxbcuVnqkS.Size = new System.Drawing.Size(68, 18);
			lxbcuVnqkS.TabIndex = 7;
			lxbcuVnqkS.Text = "Loại thẻ: ";
			btxtSerialCard.AcceptsReturn = false;
			btxtSerialCard.AcceptsTab = false;
			btxtSerialCard.AnimationSpeed = 200;
			btxtSerialCard.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.None;
			btxtSerialCard.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.None;
			btxtSerialCard.BackColor = System.Drawing.Color.White;
			btxtSerialCard.BackgroundImage = (System.Drawing.Image)resources.GetObject("btxtSerialCard.BackgroundImage");
			btxtSerialCard.BorderColorActive = System.Drawing.Color.DodgerBlue;
			btxtSerialCard.BorderColorDisabled = System.Drawing.Color.FromArgb(204, 204, 204);
			btxtSerialCard.BorderColorHover = System.Drawing.Color.FromArgb(105, 181, 255);
			btxtSerialCard.BorderColorIdle = System.Drawing.Color.DimGray;
			btxtSerialCard.BorderRadius = 1;
			btxtSerialCard.BorderThickness = 0;
			btxtSerialCard.CharacterCasing = System.Windows.Forms.CharacterCasing.Normal;
			btxtSerialCard.Cursor = System.Windows.Forms.Cursors.IBeam;
			btxtSerialCard.DefaultFont = new System.Drawing.Font("Segoe UI", 9.25f);
			btxtSerialCard.DefaultText = "";
			btxtSerialCard.FillColor = System.Drawing.Color.White;
			btxtSerialCard.HideSelection = true;
			btxtSerialCard.IconLeft = null;
			btxtSerialCard.IconLeftCursor = System.Windows.Forms.Cursors.IBeam;
			btxtSerialCard.IconPadding = 10;
			btxtSerialCard.IconRight = null;
			btxtSerialCard.IconRightCursor = System.Windows.Forms.Cursors.IBeam;
			btxtSerialCard.Lines = new string[0];
			btxtSerialCard.Location = new System.Drawing.Point(241, 334);
			btxtSerialCard.MaxLength = 32767;
			btxtSerialCard.MinimumSize = new System.Drawing.Size(1, 1);
			btxtSerialCard.Modified = false;
			btxtSerialCard.Multiline = false;
			btxtSerialCard.Name = "btxtSerialCard";
			stateProperties.BorderColor = System.Drawing.Color.DodgerBlue;
			stateProperties.FillColor = System.Drawing.Color.Empty;
			stateProperties.ForeColor = System.Drawing.Color.Empty;
			stateProperties.PlaceholderForeColor = System.Drawing.Color.Empty;
			btxtSerialCard.OnActiveState = stateProperties;
			stateProperties2.BorderColor = System.Drawing.Color.FromArgb(204, 204, 204);
			stateProperties2.FillColor = System.Drawing.Color.FromArgb(240, 240, 240);
			stateProperties2.ForeColor = System.Drawing.Color.FromArgb(109, 109, 109);
			stateProperties2.PlaceholderForeColor = System.Drawing.Color.DarkGray;
			btxtSerialCard.OnDisabledState = stateProperties2;
			stateProperties3.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			stateProperties3.FillColor = System.Drawing.Color.Empty;
			stateProperties3.ForeColor = System.Drawing.Color.Empty;
			stateProperties3.PlaceholderForeColor = System.Drawing.Color.Empty;
			btxtSerialCard.OnHoverState = stateProperties3;
			stateProperties4.BorderColor = System.Drawing.Color.DimGray;
			stateProperties4.FillColor = System.Drawing.Color.White;
			stateProperties4.ForeColor = System.Drawing.Color.Empty;
			stateProperties4.PlaceholderForeColor = System.Drawing.Color.Empty;
			btxtSerialCard.OnIdleState = stateProperties4;
			btxtSerialCard.Padding = new System.Windows.Forms.Padding(3);
			btxtSerialCard.PasswordChar = '\0';
			btxtSerialCard.PlaceholderForeColor = System.Drawing.Color.Silver;
			btxtSerialCard.PlaceholderText = "Nhập serial thẻ cào";
			btxtSerialCard.ReadOnly = false;
			btxtSerialCard.ScrollBars = System.Windows.Forms.ScrollBars.None;
			btxtSerialCard.SelectedText = "";
			btxtSerialCard.SelectionLength = 0;
			btxtSerialCard.SelectionStart = 0;
			btxtSerialCard.ShortcutsEnabled = true;
			btxtSerialCard.Size = new System.Drawing.Size(707, 32);
			btxtSerialCard.Style = Bunifu.UI.WinForms.BunifuTextBox._Style.Bunifu;
			btxtSerialCard.TabIndex = 12;
			btxtSerialCard.TextAlign = System.Windows.Forms.HorizontalAlignment.Left;
			btxtSerialCard.TextMarginBottom = 0;
			btxtSerialCard.TextMarginLeft = 3;
			btxtSerialCard.TextMarginTop = 0;
			btxtSerialCard.TextPlaceholder = "Nhập serial thẻ cào";
			btxtSerialCard.UseSystemPasswordChar = false;
			btxtSerialCard.WordWrap = true;
			btxtCodeCard.AcceptsReturn = false;
			btxtCodeCard.AcceptsTab = false;
			btxtCodeCard.AnimationSpeed = 200;
			btxtCodeCard.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.None;
			btxtCodeCard.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.None;
			btxtCodeCard.BackColor = System.Drawing.Color.White;
			btxtCodeCard.BackgroundImage = (System.Drawing.Image)resources.GetObject("btxtCodeCard.BackgroundImage");
			btxtCodeCard.BorderColorActive = System.Drawing.Color.DodgerBlue;
			btxtCodeCard.BorderColorDisabled = System.Drawing.Color.FromArgb(204, 204, 204);
			btxtCodeCard.BorderColorHover = System.Drawing.Color.FromArgb(105, 181, 255);
			btxtCodeCard.BorderColorIdle = System.Drawing.Color.DimGray;
			btxtCodeCard.BorderRadius = 1;
			btxtCodeCard.BorderThickness = 0;
			btxtCodeCard.CharacterCasing = System.Windows.Forms.CharacterCasing.Normal;
			btxtCodeCard.Cursor = System.Windows.Forms.Cursors.IBeam;
			btxtCodeCard.DefaultFont = new System.Drawing.Font("Segoe UI", 9.25f);
			btxtCodeCard.DefaultText = "";
			btxtCodeCard.FillColor = System.Drawing.Color.White;
			btxtCodeCard.HideSelection = true;
			btxtCodeCard.IconLeft = null;
			btxtCodeCard.IconLeftCursor = System.Windows.Forms.Cursors.IBeam;
			btxtCodeCard.IconPadding = 10;
			btxtCodeCard.IconRight = null;
			btxtCodeCard.IconRightCursor = System.Windows.Forms.Cursors.IBeam;
			btxtCodeCard.Lines = new string[0];
			btxtCodeCard.Location = new System.Drawing.Point(241, 281);
			btxtCodeCard.MaxLength = 32767;
			btxtCodeCard.MinimumSize = new System.Drawing.Size(1, 1);
			btxtCodeCard.Modified = false;
			btxtCodeCard.Multiline = false;
			btxtCodeCard.Name = "btxtCodeCard";
			stateProperties5.BorderColor = System.Drawing.Color.DodgerBlue;
			stateProperties5.FillColor = System.Drawing.Color.Empty;
			stateProperties5.ForeColor = System.Drawing.Color.Empty;
			stateProperties5.PlaceholderForeColor = System.Drawing.Color.Empty;
			btxtCodeCard.OnActiveState = stateProperties5;
			stateProperties6.BorderColor = System.Drawing.Color.FromArgb(204, 204, 204);
			stateProperties6.FillColor = System.Drawing.Color.FromArgb(240, 240, 240);
			stateProperties6.ForeColor = System.Drawing.Color.FromArgb(109, 109, 109);
			stateProperties6.PlaceholderForeColor = System.Drawing.Color.DarkGray;
			btxtCodeCard.OnDisabledState = stateProperties6;
			stateProperties7.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			stateProperties7.FillColor = System.Drawing.Color.Empty;
			stateProperties7.ForeColor = System.Drawing.Color.Empty;
			stateProperties7.PlaceholderForeColor = System.Drawing.Color.Empty;
			btxtCodeCard.OnHoverState = stateProperties7;
			stateProperties8.BorderColor = System.Drawing.Color.DimGray;
			stateProperties8.FillColor = System.Drawing.Color.White;
			stateProperties8.ForeColor = System.Drawing.Color.Empty;
			stateProperties8.PlaceholderForeColor = System.Drawing.Color.Empty;
			btxtCodeCard.OnIdleState = stateProperties8;
			btxtCodeCard.Padding = new System.Windows.Forms.Padding(3);
			btxtCodeCard.PasswordChar = '\0';
			btxtCodeCard.PlaceholderForeColor = System.Drawing.Color.Silver;
			btxtCodeCard.PlaceholderText = "Nhập mã thẻ cào";
			btxtCodeCard.ReadOnly = false;
			btxtCodeCard.ScrollBars = System.Windows.Forms.ScrollBars.None;
			btxtCodeCard.SelectedText = "";
			btxtCodeCard.SelectionLength = 0;
			btxtCodeCard.SelectionStart = 0;
			btxtCodeCard.ShortcutsEnabled = true;
			btxtCodeCard.Size = new System.Drawing.Size(707, 32);
			btxtCodeCard.Style = Bunifu.UI.WinForms.BunifuTextBox._Style.Bunifu;
			btxtCodeCard.TabIndex = 11;
			btxtCodeCard.TextAlign = System.Windows.Forms.HorizontalAlignment.Left;
			btxtCodeCard.TextMarginBottom = 0;
			btxtCodeCard.TextMarginLeft = 3;
			btxtCodeCard.TextMarginTop = 0;
			btxtCodeCard.TextPlaceholder = "Nhập mã thẻ cào";
			btxtCodeCard.UseSystemPasswordChar = false;
			btxtCodeCard.WordWrap = true;
			picSerialCard.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			picSerialCard.Image = Resources.serial_card;
			picSerialCard.Location = new System.Drawing.Point(46, 334);
			picSerialCard.Name = "picSerialCard";
			picSerialCard.Size = new System.Drawing.Size(197, 32);
			picSerialCard.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			picSerialCard.TabIndex = 13;
			picSerialCard.TabStop = false;
			picCodeCard.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			picCodeCard.Image = Resources.code_card;
			picCodeCard.Location = new System.Drawing.Point(46, 281);
			picCodeCard.Name = "picCodeCard";
			picCodeCard.Size = new System.Drawing.Size(197, 32);
			picCodeCard.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			picCodeCard.TabIndex = 14;
			picCodeCard.TabStop = false;
			panelCardTypes.Controls.Add(panelZing);
			panelCardTypes.Controls.Add(panelGate);
			panelCardTypes.Controls.Add(panelVcoin);
			panelCardTypes.Controls.Add(panelVina);
			panelCardTypes.Controls.Add(panelMobi);
			panelCardTypes.Controls.Add(panelViettel);
			panelCardTypes.Location = new System.Drawing.Point(42, 161);
			panelCardTypes.Name = "panelCardTypes";
			panelCardTypes.Size = new System.Drawing.Size(910, 100);
			panelCardTypes.TabIndex = 15;
			panelZing.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			panelZing.Controls.Add(picSelectZing);
			panelZing.Controls.Add(UhGclFcnaf);
			panelZing.Controls.Add(picZing);
			panelZing.Cursor = System.Windows.Forms.Cursors.Hand;
			panelZing.ForeColor = System.Drawing.Color.Black;
			panelZing.Location = new System.Drawing.Point(238, 56);
			panelZing.Name = "panelZing";
			panelZing.Size = new System.Drawing.Size(200, 40);
			panelZing.TabIndex = 7;
			panelZing.Click += new System.EventHandler(picViettel_Click);
			picSelectZing.Image = Resources._checked;
			picSelectZing.Location = new System.Drawing.Point(169, 9);
			picSelectZing.Name = "picSelectZing";
			picSelectZing.Size = new System.Drawing.Size(30, 30);
			picSelectZing.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picSelectZing.TabIndex = 2;
			picSelectZing.TabStop = false;
			picSelectZing.Visible = false;
			UhGclFcnaf.AutoSize = true;
			UhGclFcnaf.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			UhGclFcnaf.Location = new System.Drawing.Point(80, 11);
			UhGclFcnaf.Name = "lbZing";
			UhGclFcnaf.Size = new System.Drawing.Size(48, 20);
			UhGclFcnaf.TabIndex = 1;
			UhGclFcnaf.Text = "ZING";
			UhGclFcnaf.Click += new System.EventHandler(picViettel_Click);
			picZing.Image = Resources.zing;
			picZing.Location = new System.Drawing.Point(22, 4);
			picZing.Name = "picZing";
			picZing.Size = new System.Drawing.Size(55, 32);
			picZing.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picZing.TabIndex = 0;
			picZing.TabStop = false;
			picZing.Click += new System.EventHandler(picViettel_Click);
			panelGate.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			panelGate.Controls.Add(picSelectGate);
			panelGate.Controls.Add(lbGate);
			panelGate.Controls.Add(picGate);
			panelGate.Cursor = System.Windows.Forms.Cursors.Hand;
			panelGate.ForeColor = System.Drawing.Color.Black;
			panelGate.Location = new System.Drawing.Point(4, 56);
			panelGate.Name = "panelGate";
			panelGate.Size = new System.Drawing.Size(200, 40);
			panelGate.TabIndex = 8;
			panelGate.Click += new System.EventHandler(picViettel_Click);
			picSelectGate.Image = Resources._checked;
			picSelectGate.Location = new System.Drawing.Point(170, 9);
			picSelectGate.Name = "picSelectGate";
			picSelectGate.Size = new System.Drawing.Size(30, 30);
			picSelectGate.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picSelectGate.TabIndex = 2;
			picSelectGate.TabStop = false;
			picSelectGate.Visible = false;
			lbGate.AutoSize = true;
			lbGate.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbGate.Location = new System.Drawing.Point(80, 11);
			lbGate.Name = "lbGate";
			lbGate.Size = new System.Drawing.Size(78, 20);
			lbGate.TabIndex = 1;
			lbGate.Text = "FPT Gate";
			lbGate.Click += new System.EventHandler(picViettel_Click);
			picGate.Image = Resources.gate;
			picGate.Location = new System.Drawing.Point(22, 4);
			picGate.Name = "picGate";
			picGate.Size = new System.Drawing.Size(55, 32);
			picGate.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picGate.TabIndex = 0;
			picGate.TabStop = false;
			picGate.Click += new System.EventHandler(picViettel_Click);
			panelVcoin.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			panelVcoin.Controls.Add(picSelectVcoin);
			panelVcoin.Controls.Add(lbVcoin);
			panelVcoin.Controls.Add(picVcoin);
			panelVcoin.Cursor = System.Windows.Forms.Cursors.Hand;
			panelVcoin.ForeColor = System.Drawing.Color.Black;
			panelVcoin.Location = new System.Drawing.Point(706, 5);
			panelVcoin.Name = "panelVcoin";
			panelVcoin.Size = new System.Drawing.Size(200, 40);
			panelVcoin.TabIndex = 9;
			panelVcoin.Click += new System.EventHandler(picViettel_Click);
			picSelectVcoin.Image = Resources._checked;
			picSelectVcoin.Location = new System.Drawing.Point(169, 9);
			picSelectVcoin.Name = "picSelectVcoin";
			picSelectVcoin.Size = new System.Drawing.Size(30, 30);
			picSelectVcoin.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picSelectVcoin.TabIndex = 2;
			picSelectVcoin.TabStop = false;
			picSelectVcoin.Visible = false;
			lbVcoin.AutoSize = true;
			lbVcoin.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbVcoin.Location = new System.Drawing.Point(80, 11);
			lbVcoin.Name = "lbVcoin";
			lbVcoin.Size = new System.Drawing.Size(59, 20);
			lbVcoin.TabIndex = 1;
			lbVcoin.Text = "VCOIN";
			lbVcoin.Click += new System.EventHandler(picViettel_Click);
			picVcoin.Image = Resources.vcoin;
			picVcoin.Location = new System.Drawing.Point(22, 4);
			picVcoin.Name = "picVcoin";
			picVcoin.Size = new System.Drawing.Size(55, 32);
			picVcoin.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picVcoin.TabIndex = 0;
			picVcoin.TabStop = false;
			picVcoin.Click += new System.EventHandler(picViettel_Click);
			panelVina.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			panelVina.Controls.Add(picSelectVina);
			panelVina.Controls.Add(lbVina);
			panelVina.Controls.Add(picVina);
			panelVina.Cursor = System.Windows.Forms.Cursors.Hand;
			panelVina.ForeColor = System.Drawing.Color.Black;
			panelVina.Location = new System.Drawing.Point(472, 5);
			panelVina.Name = "panelVina";
			panelVina.Size = new System.Drawing.Size(200, 40);
			panelVina.TabIndex = 10;
			panelVina.Click += new System.EventHandler(picViettel_Click);
			picSelectVina.Image = Resources._checked;
			picSelectVina.Location = new System.Drawing.Point(169, 9);
			picSelectVina.Name = "picSelectVina";
			picSelectVina.Size = new System.Drawing.Size(30, 30);
			picSelectVina.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picSelectVina.TabIndex = 2;
			picSelectVina.TabStop = false;
			picSelectVina.Visible = false;
			lbVina.AutoSize = true;
			lbVina.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbVina.Location = new System.Drawing.Point(80, 11);
			lbVina.Name = "lbVina";
			lbVina.Size = new System.Drawing.Size(87, 20);
			lbVina.TabIndex = 1;
			lbVina.Text = "VinaPhone";
			lbVina.Click += new System.EventHandler(picViettel_Click);
			picVina.Image = Resources.vinaphone;
			picVina.Location = new System.Drawing.Point(22, 4);
			picVina.Name = "picVina";
			picVina.Size = new System.Drawing.Size(55, 32);
			picVina.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picVina.TabIndex = 0;
			picVina.TabStop = false;
			picVina.Click += new System.EventHandler(picViettel_Click);
			panelMobi.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			panelMobi.Controls.Add(picSelectMobi);
			panelMobi.Controls.Add(GxncioFdiP);
			panelMobi.Controls.Add(picMobi);
			panelMobi.Cursor = System.Windows.Forms.Cursors.Hand;
			panelMobi.ForeColor = System.Drawing.Color.Black;
			panelMobi.Location = new System.Drawing.Point(238, 4);
			panelMobi.Name = "panelMobi";
			panelMobi.Size = new System.Drawing.Size(200, 40);
			panelMobi.TabIndex = 11;
			panelMobi.Click += new System.EventHandler(picViettel_Click);
			picSelectMobi.Image = Resources._checked;
			picSelectMobi.Location = new System.Drawing.Point(169, 9);
			picSelectMobi.Name = "picSelectMobi";
			picSelectMobi.Size = new System.Drawing.Size(30, 30);
			picSelectMobi.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picSelectMobi.TabIndex = 2;
			picSelectMobi.TabStop = false;
			picSelectMobi.Visible = false;
			GxncioFdiP.AutoSize = true;
			GxncioFdiP.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			GxncioFdiP.Location = new System.Drawing.Point(80, 11);
			GxncioFdiP.Name = "lbMobi";
			GxncioFdiP.Size = new System.Drawing.Size(80, 20);
			GxncioFdiP.TabIndex = 1;
			GxncioFdiP.Text = "MobiFone";
			GxncioFdiP.Click += new System.EventHandler(picViettel_Click);
			picMobi.Image = Resources.mobifone;
			picMobi.Location = new System.Drawing.Point(22, 4);
			picMobi.Name = "picMobi";
			picMobi.Size = new System.Drawing.Size(55, 32);
			picMobi.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picMobi.TabIndex = 0;
			picMobi.TabStop = false;
			picMobi.Click += new System.EventHandler(picViettel_Click);
			panelViettel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			panelViettel.Controls.Add(lbViettel);
			panelViettel.Controls.Add(picSelectViettel);
			panelViettel.Controls.Add(picViettel);
			panelViettel.Cursor = System.Windows.Forms.Cursors.Hand;
			panelViettel.ForeColor = System.Drawing.Color.Black;
			panelViettel.Location = new System.Drawing.Point(4, 4);
			panelViettel.Name = "panelViettel";
			panelViettel.Size = new System.Drawing.Size(200, 40);
			panelViettel.TabIndex = 12;
			panelViettel.Click += new System.EventHandler(picViettel_Click);
			lbViettel.AutoSize = true;
			lbViettel.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbViettel.Location = new System.Drawing.Point(80, 8);
			lbViettel.Name = "lbViettel";
			lbViettel.Size = new System.Drawing.Size(72, 25);
			lbViettel.TabIndex = 1;
			lbViettel.Text = "Viettel";
			lbViettel.Click += new System.EventHandler(picViettel_Click);
			picSelectViettel.Image = Resources._checked;
			picSelectViettel.Location = new System.Drawing.Point(170, 10);
			picSelectViettel.Name = "picSelectViettel";
			picSelectViettel.Size = new System.Drawing.Size(30, 30);
			picSelectViettel.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picSelectViettel.TabIndex = 0;
			picSelectViettel.TabStop = false;
			picViettel.Image = Resources.viettel;
			picViettel.Location = new System.Drawing.Point(22, 4);
			picViettel.Name = "picViettel";
			picViettel.Size = new System.Drawing.Size(55, 32);
			picViettel.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picViettel.TabIndex = 0;
			picViettel.TabStop = false;
			picViettel.Click += new System.EventHandler(picViettel_Click);
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			BackColor = System.Drawing.Color.White;
			base.Controls.Add(panelCardTypes);
			base.Controls.Add(btxtSerialCard);
			base.Controls.Add(btxtCodeCard);
			base.Controls.Add(picSerialCard);
			base.Controls.Add(picCodeCard);
			base.Controls.Add(radioButton10);
			base.Controls.Add(radioButton5);
			base.Controls.Add(radioButton9);
			base.Controls.Add(radioButton4);
			base.Controls.Add(radioButton8);
			base.Controls.Add(radioButton7);
			base.Controls.Add(radioButton3);
			base.Controls.Add(radioButton6);
			base.Controls.Add(radioButton2);
			base.Controls.Add(radioButton1);
			base.Controls.Add(lbNote);
			base.Controls.Add(lxbcuVnqkS);
			base.Controls.Add(label10);
			base.Controls.Add(panel1);
			base.Controls.Add(picBoxReset);
			base.Controls.Add(picBoxTopUp);
			base.Controls.Add(label1);
			base.Name = "TopUp";
			base.Size = new System.Drawing.Size(1000, 595);
			base.Load += new System.EventHandler(TopUp_Load);
			base.Enter += new System.EventHandler(TopUp_Enter);
			((System.ComponentModel.ISupportInitialize)picBoxReset).EndInit();
			((System.ComponentModel.ISupportInitialize)picBoxTopUp).EndInit();
			panel1.ResumeLayout(false);
			panel1.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picSerialCard).EndInit();
			((System.ComponentModel.ISupportInitialize)picCodeCard).EndInit();
			panelCardTypes.ResumeLayout(false);
			panelZing.ResumeLayout(false);
			panelZing.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picSelectZing).EndInit();
			((System.ComponentModel.ISupportInitialize)picZing).EndInit();
			panelGate.ResumeLayout(false);
			panelGate.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picSelectGate).EndInit();
			((System.ComponentModel.ISupportInitialize)picGate).EndInit();
			panelVcoin.ResumeLayout(false);
			panelVcoin.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picSelectVcoin).EndInit();
			((System.ComponentModel.ISupportInitialize)picVcoin).EndInit();
			panelVina.ResumeLayout(false);
			panelVina.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picSelectVina).EndInit();
			((System.ComponentModel.ISupportInitialize)picVina).EndInit();
			panelMobi.ResumeLayout(false);
			panelMobi.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picSelectMobi).EndInit();
			((System.ComponentModel.ISupportInitialize)picMobi).EndInit();
			panelViettel.ResumeLayout(false);
			panelViettel.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picSelectViettel).EndInit();
			((System.ComponentModel.ISupportInitialize)picViettel).EndInit();
			ResumeLayout(false);
			PerformLayout();
		}

		internal static bool lfc6Zm0Eqme9sjT7crR()
		{
			return W43M4G033fRNWZHFZrJ == null;
		}

		internal static void NQrPu9G9DkBFdjmqB5p()
		{
		}
	}
}
