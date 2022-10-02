using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Windows.Forms;
using Bunifu.UI.WinForms;
using Launcher.Properties;
using Launcher.Statics;
using Properties;

namespace Launcher.UserControls
{
	public class Exchange : UserControl
	{
		private readonly Main main_0 = Main.Instance;

		private double double_0;

		private BackgroundWorker backgroundWorker_0;

		private string string_0 = "";

		private Dictionary<int, string> dictionary_0 = new Dictionary<int, string>();

		private Dictionary<int, string> dictionary_1 = new Dictionary<int, string>();

		private int int_0 = 1;

		private IContainer icontainer_0;

		private Label label1;

		private Panel panel1;

		private Label labelCash;

		private Label label4;

		private Label label2;

		private PictureBox picBoxExchange;

		private PictureBox picBoxReset;

		private Label label8;

		private BunifuTextBox bTxtPassBag;

		private BunifuDropdown bdrdSelectServer;

		private PictureBox picSelectServer;

		private PictureBox picPassBag;

		private PictureBox picSelectChar;

		private BunifuDropdown bDrdSelectChar;

		private PictureBox picMoney;

		private BunifuTextBox bTxtMoney;

		private Label lbStatus;

		private Timer timer_0;

		private PictureBox picGiftCanGet;

		private BunifuTextBox bTxtGiftCanGet;
        private IContainer components;
        internal static Exchange R6P7vB86w4XMFyyNLO2;

		public Exchange()
		{
			InitializeComponent();
			bdrdSelectServer.Height = (bDrdSelectChar.Height = main_0.FixScaling(32));
			picSelectServer.Height = (picSelectChar.Height = bdrdSelectServer.Height);
			bTxtPassBag.Height = (bTxtMoney.Height = (bTxtGiftCanGet.Height = main_0.FixScaling(32)));
			picPassBag.Height = (picMoney.Height = (picGiftCanGet.Height = bTxtPassBag.Height));
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
			lbStatus.Visible = false;
			picBoxExchange.Enabled = true;
			picBoxExchange.Image = Resources.exchange;
			picBoxReset.Enabled = true;
			picBoxReset.Image = Resources.Reset;
			MessageBox.Show(string_0);
		}

		private void backgroundWorker_0_DoWork(object sender, DoWorkEventArgs e)
		{
			ExchangeMoney();
		}

		private void CashInfo()
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
					double num = (double_0 = double.Parse(text.Split(':')[1]));
					labelCash.Text = num.ToString("n", CultureInfo.GetCultureInfo("vi-VN")).Replace(",00", "");
				}
				else
				{
					DDTStaticFunc.AddUpdateLogs("Exchange Refresh Cash", DDTStaticFunc.Host + Resources.CashInfo + " result:" + text);
					labelCash.Text = "0";
				}
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 5c " + ex.Message, $"result:{text},  \nerrors:{ex}");
			}
			Cursor = Cursors.Default;
		}

		private string method_1(int int_1)
		{
			string text = "-1;Máy chủ không tồn tại";
			if (dictionary_0.ContainsKey(int_1))
			{
				text = dictionary_0[int_1];
			}
			string[] array = text.Split(';');
			if (array.Length < 2)
			{
				return "-1";
			}
			return array[0];
		}

		private string method_2(int int_1)
		{
			string text = "0;-1;Bạn chưa tạo nhân vật tại máy chủ này";
			if (dictionary_1.ContainsKey(int_1))
			{
				text = dictionary_1[int_1];
			}
			string[] array = text.Split(';');
			if (array.Length < 3)
			{
				return "-1";
			}
			return array[1];
		}

		private void ExchangeMoney()
		{
			if (InvokeRequired) // Line #1
			{
				this.Invoke(new MethodInvoker(ExchangeMoney));
				return;
			}
			string text = method_2(bDrdSelectChar.SelectedIndex);
			string text2 = method_1(bdrdSelectServer.SelectedIndex);
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
				{ "userId", text },
				{ "areaId", text2 },
				{ "cash", bTxtMoney.Text },
				{ "bagpass", bTxtPassBag.Text },
				{
					"key",
					Util.MD5(text + text2 + Resources.PublicKey)
				}
			};
			string arg = ControlMgr.Post(DDTStaticFunc.Host + Resources.ExchangeUrl, param);
			try
			{
				string_0 = arg;
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception ExchangeMoney " + ex.Message, $"result:{arg},  \nerrors:{ex}");
			}
			finally
			{
				CashInfo();
				main_0.lbCash.Text = labelCash.Text;
			}
		}

		private void method_4()
		{
			List<ServerListInfo> list = ServerConfig.Servers.Values.ToList();
			bdrdSelectServer.Items.Clear();
			int num = 0;
			foreach (ServerListInfo item in list)
			{
				bdrdSelectServer.Items.Add(item.Name);
				if (!dictionary_0.ContainsKey(num))
				{
					dictionary_0[num] = $"{item.ID};{item.Name}";
				}
				num++;
			}
		}

		private void Exchange_Load(object sender, EventArgs e)
		{
			lbStatus.Visible = false;
		}

		private void Exchange_Enter(object sender, EventArgs e)
		{
			CashInfo();
			dictionary_0 = new Dictionary<int, string>();
			method_4();
			bDrdSelectChar.Enabled = false;
		}

		private void picBoxExchange_MouseHover(object sender, EventArgs e)
		{
			if (picBoxExchange.Enabled)
			{
				picBoxExchange.Image = Resources.exchange_Over;
			}
		}

		private void picBoxExchange_MouseLeave(object sender, EventArgs e)
		{
			if (picBoxExchange.Enabled)
			{
				picBoxExchange.Image = Resources.exchange;
			}
		}

		private void picBoxReset_MouseHover(object sender, EventArgs e)
		{
			picBoxReset.Image = Resources.Reset_Over;
		}

		private void picBoxReset_MouseLeave(object sender, EventArgs e)
		{
			picBoxReset.Image = Resources.Reset;
		}

		private void picBoxExchange_Click(object sender, EventArgs e)
		{
			lbStatus.Visible = false;
			if (picBoxExchange.Enabled)
			{
				int result;
				if (bdrdSelectServer.SelectedIndex == -1)
				{
					MessageBox.Show("Bạn chưa chọn máy chủ!");
				}
				else if (bDrdSelectChar.SelectedIndex == -1)
				{
					MessageBox.Show("Bạn chưa chọn nhân vật!");
				}
				else if (string.IsNullOrEmpty(bTxtMoney.Text))
				{
					MessageBox.Show("Bạn chưa nhập cash!");
				}
				else if (int.TryParse(bTxtMoney.Text, out result))
				{
					if (result >= 1000)
					{
						picBoxExchange.Enabled = false;
						picBoxExchange.Image = Resources.exchange_disable;
						picBoxReset.Enabled = false;
						picBoxReset.Image = Resources.Reset_Disable;
						int_0 = 1;
						lbStatus.Text = "Đang xử lý";
						lbStatus.Visible = true;
						timer_0.Start();
					}
					else
					{
						MessageBox.Show("Cash nhập vào phải lớn hơn 999");
					}
				}
				else
				{
					MessageBox.Show("Cash nhập vào không hợp lệ, giá trị nhập vào phải là 1 số.");
				}
			}
			else
			{
				MessageBox.Show("Hệ thống đang bận, vui lòng đợi.");
			}
		}

		private void picBoxReset_Click(object sender, EventArgs e)
		{
			lbStatus.Visible = false;
			picBoxExchange.Enabled = true;
			picBoxExchange.Image = Resources.exchange;
			bTxtMoney.Text = "";
			bTxtMoney.PlaceholderText = nhapCashLabelFormat();
			bTxtPassBag.Text = "";
			bTxtPassBag.PlaceholderText = Resources.BagPassword;
			bTxtPassBag.ForeColor = Color.Silver;
			bTxtPassBag.UseSystemPasswordChar = false;
			bdrdSelectServer.SelectedIndex = -1;
			bdrdSelectServer.Text = "Chọn máy chủ";
			bdrdSelectServer.ForeColor = Color.Silver;
			bdrdSelectServer.Focus();
			method_5();
		}

		private void method_5()
		{
			bDrdSelectChar.SelectedIndex = -1;
			bDrdSelectChar.Text = "Chọn nhân vật muốn nhận xu";
			bDrdSelectChar.ForeColor = Color.Silver;
			bDrdSelectChar.Enabled = false;
			dictionary_1 = new Dictionary<int, string>();
		}

		private void bDrdSelectChar_SelectedIndexChanged(object sender, EventArgs e)
		{
			if (sender is BunifuDropdown)
			{
				(sender as BunifuDropdown).ForeColor = Color.Black;
			}
		}

		private void bTxtPassBag_Enter(object sender, EventArgs e)
		{
			if (bTxtPassBag.PlaceholderText == Resources.BagPassword)
			{
				bTxtPassBag.PlaceholderText = "";
				bTxtPassBag.ForeColor = Color.Black;
				bTxtPassBag.UseSystemPasswordChar = true;
			}
		}

		private void bTxtPassBag_Leave(object sender, EventArgs e)
		{
			if (bTxtPassBag.Text == "")
			{
				bTxtPassBag.PlaceholderText = Resources.BagPassword;
				bTxtPassBag.ForeColor = Color.Silver;
				bTxtPassBag.UseSystemPasswordChar = false;
			}
		}

		private void bTxtGiftCanGet_Enter(object sender, EventArgs e)
		{
			if (bTxtMoney.PlaceholderText == nhapCashLabelFormat())
			{
				bTxtMoney.PlaceholderText = "";
				bTxtMoney.ForeColor = Color.Black;
			}
		}

		private void bTxtGiftCanGet_Leave(object sender, EventArgs e)
		{
			if (bTxtMoney.Text == "")
			{
				bTxtMoney.PlaceholderText = nhapCashLabelFormat();
				bTxtMoney.ForeColor = Color.Silver;
			}
		}

		private void bdrdSelectServer_SelectedValueChanged(object sender, EventArgs e)
		{
			method_5();
			lbStatus.Visible = false;
			bDrdSelectChar.Enabled = true;
			bDrdSelectChar.Items.Clear();
			Cursor = Cursors.WaitCursor;
			string text = method_1(bdrdSelectServer.SelectedIndex);
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
				{ "srv", text },
				{
					"key",
					Util.MD5(LoginMgr.Username + text + Resources.PublicKey)
				}
			};
			string text2 = ControlMgr.Post(DDTStaticFunc.Host + Resources.LoadChars, param);
			try
			{
				string[] array = text2.Split('|');
				if (array.Length == 0)
				{
					lbStatus.Visible = true;
					lbStatus.Text = "Tải danh sách nhân vật thất bại.";
					DDTStaticFunc.AddUpdateLogs("BdrdSelectServer SelectedValueChanged", DDTStaticFunc.Host + Resources.LoadChars + " result:" + text2);
				}
				else
				{
					int num = 0;
					string[] array2 = array;
					foreach (string text3 in array2)
					{
						string[] array3 = text3.Split(';');
						num = int.Parse(array3[0]);
						if (!dictionary_1.ContainsKey(num))
						{
							dictionary_1[num] = text3;
						}
						bDrdSelectChar.Items.Add(array3[2]);
					}
				}
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception BdrdSelectServer_SelectedValueChanged " + ex.Message, $"result:{text2},  \nerrors:{ex}");
			}
			Cursor = Cursors.Default;
		}

		private void bTxtGiftCanGet_TextChange(object sender, EventArgs e)
		{
			if (string.IsNullOrEmpty(bTxtMoney.Text))
			{
				bTxtGiftCanGet.Text = "";
				return;
			}
			try
			{
				double num = int.Parse(bTxtMoney.Text);
				if (num > double_0)
				{
					bTxtMoney.Text = double_0.ToString();
				}
				int num2 = (int)Math.Abs(num * ServerConfig.ConfigXu);
				bTxtGiftCanGet.Text = num2.ToString("n", CultureInfo.GetCultureInfo("vi-VN")).Replace(",00", "") + " xu";
			}
			catch
			{
				bTxtMoney.Text = double_0.ToString();
				bTxtGiftCanGet.Text = "";
			}
		}

		private void timer_0_Tick(object sender, EventArgs e)
		{
			lbStatus.Text = $"Đang xử lý ({int_0}s)";
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

		private string nhapCashLabelFormat()
		{
			int maxAmount = 10000;
			if (ServerConfig.ConfigXu >= 1) {
					maxAmount = 1;
			}

			string maxAmountText = maxAmount.ToString("n", CultureInfo.GetCultureInfo("vi-VN")).Replace(",00", "");
			string moneyExchange = (maxAmount * ServerConfig.ConfigXu).ToString("n", CultureInfo.GetCultureInfo("vi-VN")).Replace(",00", "");
			return string.Format("Nhập số lượng cash muốn đổi. ({0}  cash = {1} xu)", maxAmountText, moneyExchange);
        }

		private void InitializeComponent()
		{
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Exchange));
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties1 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties2 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties3 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties4 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties5 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties6 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties7 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties8 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties9 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties10 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties11 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties12 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
            this.label1 = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.labelCash = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.picBoxExchange = new System.Windows.Forms.PictureBox();
            this.picBoxReset = new System.Windows.Forms.PictureBox();
            this.label8 = new System.Windows.Forms.Label();
            this.bTxtPassBag = new Bunifu.UI.WinForms.BunifuTextBox();
            this.bdrdSelectServer = new Bunifu.UI.WinForms.BunifuDropdown();
            this.picSelectServer = new System.Windows.Forms.PictureBox();
            this.picPassBag = new System.Windows.Forms.PictureBox();
            this.picSelectChar = new System.Windows.Forms.PictureBox();
            this.bDrdSelectChar = new Bunifu.UI.WinForms.BunifuDropdown();
            this.picMoney = new System.Windows.Forms.PictureBox();
            this.bTxtMoney = new Bunifu.UI.WinForms.BunifuTextBox();
            this.lbStatus = new System.Windows.Forms.Label();
            this.timer_0 = new System.Windows.Forms.Timer(this.components);
            this.picGiftCanGet = new System.Windows.Forms.PictureBox();
            this.bTxtGiftCanGet = new Bunifu.UI.WinForms.BunifuTextBox();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxExchange)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxReset)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picSelectServer)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picPassBag)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picSelectChar)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picMoney)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picGiftCanGet)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 20.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.Black;
            this.label1.Location = new System.Drawing.Point(398, 23);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(146, 31);
            this.label1.TabIndex = 0;
            this.label1.Text = "ĐỔI CASH";
            // 
            // panel1
            // 
            this.panel1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
            this.panel1.BackColor = System.Drawing.Color.WhiteSmoke;
            this.panel1.Controls.Add(this.labelCash);
            this.panel1.Controls.Add(this.label4);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Location = new System.Drawing.Point(0, 85);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1000, 40);
            this.panel1.TabIndex = 1;
            // 
            // labelCash
            // 
            this.labelCash.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelCash.ForeColor = System.Drawing.Color.DarkGreen;
            this.labelCash.Location = new System.Drawing.Point(102, 12);
            this.labelCash.Name = "labelCash";
            this.labelCash.Size = new System.Drawing.Size(86, 16);
            this.labelCash.TabIndex = 0;
            this.labelCash.Text = "99.999.999";
            this.labelCash.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.Red;
            this.label4.Location = new System.Drawing.Point(187, 12);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(43, 16);
            this.label4.TabIndex = 0;
            this.label4.Text = "Cash";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.Black;
            this.label2.Location = new System.Drawing.Point(15, 12);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(86, 16);
            this.label2.TabIndex = 0;
            this.label2.Text = "Hiện tại có:";
            // 
            // picBoxExchange
            // 
            this.picBoxExchange.BackColor = System.Drawing.Color.Transparent;
            this.picBoxExchange.Cursor = System.Windows.Forms.Cursors.Hand;
            this.picBoxExchange.Image = global::Properties.Resources.exchange;
            this.picBoxExchange.Location = new System.Drawing.Point(362, 478);
            this.picBoxExchange.Name = "picBoxExchange";
            this.picBoxExchange.Size = new System.Drawing.Size(135, 40);
            this.picBoxExchange.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxExchange.TabIndex = 2;
            this.picBoxExchange.TabStop = false;
            this.picBoxExchange.Click += new System.EventHandler(this.picBoxExchange_Click);
            this.picBoxExchange.MouseLeave += new System.EventHandler(this.picBoxExchange_MouseLeave);
            this.picBoxExchange.MouseHover += new System.EventHandler(this.picBoxExchange_MouseHover);
            // 
            // picBoxReset
            // 
            this.picBoxReset.BackColor = System.Drawing.Color.Transparent;
            this.picBoxReset.Cursor = System.Windows.Forms.Cursors.Hand;
            this.picBoxReset.Image = global::Properties.Resources.Reset;
            this.picBoxReset.Location = new System.Drawing.Point(506, 478);
            this.picBoxReset.Name = "picBoxReset";
            this.picBoxReset.Size = new System.Drawing.Size(100, 40);
            this.picBoxReset.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxReset.TabIndex = 2;
            this.picBoxReset.TabStop = false;
            this.picBoxReset.Click += new System.EventHandler(this.picBoxReset_Click);
            this.picBoxReset.MouseLeave += new System.EventHandler(this.picBoxReset_MouseLeave);
            this.picBoxReset.MouseHover += new System.EventHandler(this.picBoxReset_MouseHover);
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.Color.Red;
            this.label8.Location = new System.Drawing.Point(279, 141);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(447, 16);
            this.label8.TabIndex = 6;
            this.label8.Text = " Lưu ý: Chuyển đổi thành công hệ thống sẽ gửi vào thư trong game cho bạn.";
            // 
            // bTxtPassBag
            // 
            this.bTxtPassBag.AcceptsReturn = false;
            this.bTxtPassBag.AcceptsTab = false;
            this.bTxtPassBag.AnimationSpeed = 200;
            this.bTxtPassBag.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.None;
            this.bTxtPassBag.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.None;
            this.bTxtPassBag.BackColor = System.Drawing.Color.White;
            this.bTxtPassBag.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("bTxtPassBag.BackgroundImage")));
            this.bTxtPassBag.BorderColorActive = System.Drawing.Color.DodgerBlue;
            this.bTxtPassBag.BorderColorDisabled = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.bTxtPassBag.BorderColorHover = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            this.bTxtPassBag.BorderColorIdle = System.Drawing.Color.DimGray;
            this.bTxtPassBag.BorderRadius = 1;
            this.bTxtPassBag.BorderThickness = 0;
            this.bTxtPassBag.CharacterCasing = System.Windows.Forms.CharacterCasing.Normal;
            this.bTxtPassBag.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.bTxtPassBag.DefaultFont = new System.Drawing.Font("Segoe UI", 11.25F);
            this.bTxtPassBag.DefaultText = "";
            this.bTxtPassBag.FillColor = System.Drawing.Color.White;
            this.bTxtPassBag.HideSelection = true;
            this.bTxtPassBag.IconLeft = null;
            this.bTxtPassBag.IconLeftCursor = System.Windows.Forms.Cursors.IBeam;
            this.bTxtPassBag.IconPadding = 10;
            this.bTxtPassBag.IconRight = null;
            this.bTxtPassBag.IconRightCursor = System.Windows.Forms.Cursors.IBeam;
            this.bTxtPassBag.Lines = new string[0];
            this.bTxtPassBag.Location = new System.Drawing.Point(85, 284);
            this.bTxtPassBag.MaxLength = 32767;
            this.bTxtPassBag.MinimumSize = new System.Drawing.Size(1, 1);
            this.bTxtPassBag.Modified = false;
            this.bTxtPassBag.Multiline = false;
            this.bTxtPassBag.Name = "bTxtPassBag";
            stateProperties1.BorderColor = System.Drawing.Color.DodgerBlue;
            stateProperties1.FillColor = System.Drawing.Color.Empty;
            stateProperties1.ForeColor = System.Drawing.Color.Empty;
            stateProperties1.PlaceholderForeColor = System.Drawing.Color.Empty;
            this.bTxtPassBag.OnActiveState = stateProperties1;
            stateProperties2.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            stateProperties2.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            stateProperties2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            stateProperties2.PlaceholderForeColor = System.Drawing.Color.DarkGray;
            this.bTxtPassBag.OnDisabledState = stateProperties2;
            stateProperties3.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            stateProperties3.FillColor = System.Drawing.Color.Empty;
            stateProperties3.ForeColor = System.Drawing.Color.Empty;
            stateProperties3.PlaceholderForeColor = System.Drawing.Color.Empty;
            this.bTxtPassBag.OnHoverState = stateProperties3;
            stateProperties4.BorderColor = System.Drawing.Color.DimGray;
            stateProperties4.FillColor = System.Drawing.Color.White;
            stateProperties4.ForeColor = System.Drawing.Color.Empty;
            stateProperties4.PlaceholderForeColor = System.Drawing.Color.Empty;
            this.bTxtPassBag.OnIdleState = stateProperties4;
            this.bTxtPassBag.Padding = new System.Windows.Forms.Padding(3);
            this.bTxtPassBag.PasswordChar = '\0';
            this.bTxtPassBag.PlaceholderForeColor = System.Drawing.Color.Silver;
            this.bTxtPassBag.PlaceholderText = "Nhập mật khẩu rương nhân vật";
            this.bTxtPassBag.ReadOnly = false;
            this.bTxtPassBag.ScrollBars = System.Windows.Forms.ScrollBars.None;
            this.bTxtPassBag.SelectedText = "";
            this.bTxtPassBag.SelectionLength = 0;
            this.bTxtPassBag.SelectionStart = 0;
            this.bTxtPassBag.ShortcutsEnabled = true;
            this.bTxtPassBag.Size = new System.Drawing.Size(887, 32);
            this.bTxtPassBag.Style = Bunifu.UI.WinForms.BunifuTextBox._Style.Bunifu;
            this.bTxtPassBag.TabIndex = 8;
            this.bTxtPassBag.TextAlign = System.Windows.Forms.HorizontalAlignment.Left;
            this.bTxtPassBag.TextMarginBottom = 0;
            this.bTxtPassBag.TextMarginLeft = 3;
            this.bTxtPassBag.TextMarginTop = 0;
            this.bTxtPassBag.TextPlaceholder = "Nhập mật khẩu rương nhân vật";
            this.bTxtPassBag.UseSystemPasswordChar = false;
            this.bTxtPassBag.WordWrap = true;
            this.bTxtPassBag.Enter += new System.EventHandler(this.bTxtPassBag_Enter);
            this.bTxtPassBag.Leave += new System.EventHandler(this.bTxtPassBag_Leave);
            // 
            // bdrdSelectServer
            // 
            this.bdrdSelectServer.BackColor = System.Drawing.Color.White;
            this.bdrdSelectServer.BackgroundColor = System.Drawing.Color.White;
            this.bdrdSelectServer.BorderColor = System.Drawing.Color.DimGray;
            this.bdrdSelectServer.BorderRadius = 1;
            this.bdrdSelectServer.Color = System.Drawing.Color.DimGray;
            this.bdrdSelectServer.Direction = Bunifu.UI.WinForms.BunifuDropdown.Directions.Down;
            this.bdrdSelectServer.DisabledBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.bdrdSelectServer.DisabledBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.bdrdSelectServer.DisabledColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.bdrdSelectServer.DisabledForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            this.bdrdSelectServer.DisabledIndicatorColor = System.Drawing.Color.DarkGray;
            this.bdrdSelectServer.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.bdrdSelectServer.DropdownBorderThickness = Bunifu.UI.WinForms.BunifuDropdown.BorderThickness.Thin;
            this.bdrdSelectServer.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.bdrdSelectServer.DropDownTextAlign = Bunifu.UI.WinForms.BunifuDropdown.TextAlign.Left;
            this.bdrdSelectServer.FillDropDown = true;
            this.bdrdSelectServer.FillIndicator = false;
            this.bdrdSelectServer.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.bdrdSelectServer.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bdrdSelectServer.ForeColor = System.Drawing.Color.Silver;
            this.bdrdSelectServer.FormattingEnabled = true;
            this.bdrdSelectServer.Icon = null;
            this.bdrdSelectServer.IndicatorAlignment = Bunifu.UI.WinForms.BunifuDropdown.Indicator.Right;
            this.bdrdSelectServer.IndicatorColor = System.Drawing.Color.Gray;
            this.bdrdSelectServer.IndicatorLocation = Bunifu.UI.WinForms.BunifuDropdown.Indicator.Right;
            this.bdrdSelectServer.ItemBackColor = System.Drawing.Color.White;
            this.bdrdSelectServer.ItemBorderColor = System.Drawing.Color.White;
            this.bdrdSelectServer.ItemForeColor = System.Drawing.Color.Black;
            this.bdrdSelectServer.ItemHeight = 26;
            this.bdrdSelectServer.ItemHighLightColor = System.Drawing.Color.DodgerBlue;
            this.bdrdSelectServer.ItemHighLightForeColor = System.Drawing.Color.White;
            this.bdrdSelectServer.Items.AddRange(new object[] {
            "Chapter 1",
            "Chapter 2",
            "Chapter 3",
            "Chapter 4"});
            this.bdrdSelectServer.ItemTopMargin = 3;
            this.bdrdSelectServer.Location = new System.Drawing.Point(85, 178);
            this.bdrdSelectServer.Name = "bdrdSelectServer";
            this.bdrdSelectServer.Size = new System.Drawing.Size(887, 32);
            this.bdrdSelectServer.TabIndex = 7;
            this.bdrdSelectServer.Text = "Chọn máy chủ";
            this.bdrdSelectServer.TextAlignment = Bunifu.UI.WinForms.BunifuDropdown.TextAlign.Left;
            this.bdrdSelectServer.TextLeftMargin = 5;
            this.bdrdSelectServer.SelectedIndexChanged += new System.EventHandler(this.bDrdSelectChar_SelectedIndexChanged);
            this.bdrdSelectServer.SelectedValueChanged += new System.EventHandler(this.bdrdSelectServer_SelectedValueChanged);
            // 
            // picSelectServer
            // 
            this.picSelectServer.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picSelectServer.Image = global::Properties.Resources.list_items;
            this.picSelectServer.Location = new System.Drawing.Point(22, 178);
            this.picSelectServer.Name = "picSelectServer";
            this.picSelectServer.Size = new System.Drawing.Size(65, 32);
            this.picSelectServer.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picSelectServer.TabIndex = 9;
            this.picSelectServer.TabStop = false;
            // 
            // picPassBag
            // 
            this.picPassBag.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picPassBag.Image = global::Properties.Resources._lock;
            this.picPassBag.Location = new System.Drawing.Point(22, 284);
            this.picPassBag.Name = "picPassBag";
            this.picPassBag.Size = new System.Drawing.Size(65, 32);
            this.picPassBag.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picPassBag.TabIndex = 10;
            this.picPassBag.TabStop = false;
            // 
            // picSelectChar
            // 
            this.picSelectChar.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picSelectChar.Image = global::Properties.Resources.multiple_users_silhouette;
            this.picSelectChar.Location = new System.Drawing.Point(22, 230);
            this.picSelectChar.Name = "picSelectChar";
            this.picSelectChar.Size = new System.Drawing.Size(65, 32);
            this.picSelectChar.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picSelectChar.TabIndex = 9;
            this.picSelectChar.TabStop = false;
            // 
            // bDrdSelectChar
            // 
            this.bDrdSelectChar.BackColor = System.Drawing.Color.White;
            this.bDrdSelectChar.BackgroundColor = System.Drawing.Color.White;
            this.bDrdSelectChar.BorderColor = System.Drawing.Color.DimGray;
            this.bDrdSelectChar.BorderRadius = 1;
            this.bDrdSelectChar.Color = System.Drawing.Color.DimGray;
            this.bDrdSelectChar.Direction = Bunifu.UI.WinForms.BunifuDropdown.Directions.Down;
            this.bDrdSelectChar.DisabledBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.bDrdSelectChar.DisabledBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.bDrdSelectChar.DisabledColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.bDrdSelectChar.DisabledForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            this.bDrdSelectChar.DisabledIndicatorColor = System.Drawing.Color.DarkGray;
            this.bDrdSelectChar.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.bDrdSelectChar.DropdownBorderThickness = Bunifu.UI.WinForms.BunifuDropdown.BorderThickness.Thin;
            this.bDrdSelectChar.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.bDrdSelectChar.DropDownTextAlign = Bunifu.UI.WinForms.BunifuDropdown.TextAlign.Left;
            this.bDrdSelectChar.FillDropDown = true;
            this.bDrdSelectChar.FillIndicator = false;
            this.bDrdSelectChar.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.bDrdSelectChar.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bDrdSelectChar.ForeColor = System.Drawing.Color.Silver;
            this.bDrdSelectChar.FormattingEnabled = true;
            this.bDrdSelectChar.Icon = null;
            this.bDrdSelectChar.IndicatorAlignment = Bunifu.UI.WinForms.BunifuDropdown.Indicator.Right;
            this.bDrdSelectChar.IndicatorColor = System.Drawing.Color.Gray;
            this.bDrdSelectChar.IndicatorLocation = Bunifu.UI.WinForms.BunifuDropdown.Indicator.Right;
            this.bDrdSelectChar.ItemBackColor = System.Drawing.Color.White;
            this.bDrdSelectChar.ItemBorderColor = System.Drawing.Color.White;
            this.bDrdSelectChar.ItemForeColor = System.Drawing.Color.Black;
            this.bDrdSelectChar.ItemHeight = 26;
            this.bDrdSelectChar.ItemHighLightColor = System.Drawing.Color.DodgerBlue;
            this.bDrdSelectChar.ItemHighLightForeColor = System.Drawing.Color.White;
            this.bDrdSelectChar.Items.AddRange(new object[] {
            "Chapter 1",
            "Chapter 2",
            "Chapter 3",
            "Chapter 4"});
            this.bDrdSelectChar.ItemTopMargin = 3;
            this.bDrdSelectChar.Location = new System.Drawing.Point(85, 230);
            this.bDrdSelectChar.Name = "bDrdSelectChar";
            this.bDrdSelectChar.Size = new System.Drawing.Size(887, 32);
            this.bDrdSelectChar.TabIndex = 7;
            this.bDrdSelectChar.Text = "Chọn nhân vật muốn nhận xu";
            this.bDrdSelectChar.TextAlignment = Bunifu.UI.WinForms.BunifuDropdown.TextAlign.Left;
            this.bDrdSelectChar.TextLeftMargin = 5;
            this.bDrdSelectChar.SelectedIndexChanged += new System.EventHandler(this.bDrdSelectChar_SelectedIndexChanged);
            // 
            // picMoney
            // 
            this.picMoney.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picMoney.Image = global::Properties.Resources.money;
            this.picMoney.Location = new System.Drawing.Point(22, 337);
            this.picMoney.Name = "picMoney";
            this.picMoney.Size = new System.Drawing.Size(65, 32);
            this.picMoney.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picMoney.TabIndex = 10;
            this.picMoney.TabStop = false;
            // 
            // bTxtMoney
            // 
            this.bTxtMoney.AcceptsReturn = false;
            this.bTxtMoney.AcceptsTab = false;
            this.bTxtMoney.AnimationSpeed = 200;
            this.bTxtMoney.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.None;
            this.bTxtMoney.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.None;
            this.bTxtMoney.BackColor = System.Drawing.Color.White;
            this.bTxtMoney.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("bTxtMoney.BackgroundImage")));
            this.bTxtMoney.BorderColorActive = System.Drawing.Color.DodgerBlue;
            this.bTxtMoney.BorderColorDisabled = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.bTxtMoney.BorderColorHover = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            this.bTxtMoney.BorderColorIdle = System.Drawing.Color.DimGray;
            this.bTxtMoney.BorderRadius = 1;
            this.bTxtMoney.BorderThickness = 0;
            this.bTxtMoney.CharacterCasing = System.Windows.Forms.CharacterCasing.Normal;
            this.bTxtMoney.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.bTxtMoney.DefaultFont = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bTxtMoney.DefaultText = "";
            this.bTxtMoney.FillColor = System.Drawing.Color.White;
            this.bTxtMoney.HideSelection = true;
            this.bTxtMoney.IconLeft = null;
            this.bTxtMoney.IconLeftCursor = System.Windows.Forms.Cursors.IBeam;
            this.bTxtMoney.IconPadding = 10;
            this.bTxtMoney.IconRight = null;
            this.bTxtMoney.IconRightCursor = System.Windows.Forms.Cursors.IBeam;
            this.bTxtMoney.Lines = new string[0];
            this.bTxtMoney.Location = new System.Drawing.Point(85, 337);
            this.bTxtMoney.MaxLength = 32767;
            this.bTxtMoney.MinimumSize = new System.Drawing.Size(1, 1);
            this.bTxtMoney.Modified = false;
            this.bTxtMoney.Multiline = false;
            this.bTxtMoney.Name = "bTxtMoney";
            stateProperties5.BorderColor = System.Drawing.Color.DodgerBlue;
            stateProperties5.FillColor = System.Drawing.Color.Empty;
            stateProperties5.ForeColor = System.Drawing.Color.Empty;
            stateProperties5.PlaceholderForeColor = System.Drawing.Color.Empty;
            this.bTxtMoney.OnActiveState = stateProperties5;
            stateProperties6.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            stateProperties6.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            stateProperties6.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            stateProperties6.PlaceholderForeColor = System.Drawing.Color.DarkGray;
            this.bTxtMoney.OnDisabledState = stateProperties6;
            stateProperties7.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            stateProperties7.FillColor = System.Drawing.Color.Empty;
            stateProperties7.ForeColor = System.Drawing.Color.Empty;
            stateProperties7.PlaceholderForeColor = System.Drawing.Color.Empty;
            this.bTxtMoney.OnHoverState = stateProperties7;
            stateProperties8.BorderColor = System.Drawing.Color.DimGray;
            stateProperties8.FillColor = System.Drawing.Color.White;
            stateProperties8.ForeColor = System.Drawing.Color.Empty;
            stateProperties8.PlaceholderForeColor = System.Drawing.Color.Empty;
            this.bTxtMoney.OnIdleState = stateProperties8;
            this.bTxtMoney.Padding = new System.Windows.Forms.Padding(3);
            this.bTxtMoney.PasswordChar = '\0';
            this.bTxtMoney.PlaceholderForeColor = System.Drawing.Color.Silver;
            this.bTxtMoney.PlaceholderText = "Enter text";
            this.bTxtMoney.ReadOnly = false;
            this.bTxtMoney.ScrollBars = System.Windows.Forms.ScrollBars.None;
            this.bTxtMoney.SelectedText = "";
            this.bTxtMoney.SelectionLength = 0;
            this.bTxtMoney.SelectionStart = 0;
            this.bTxtMoney.ShortcutsEnabled = true;
            this.bTxtMoney.Size = new System.Drawing.Size(887, 32);
            this.bTxtMoney.Style = Bunifu.UI.WinForms.BunifuTextBox._Style.Bunifu;
            this.bTxtMoney.TabIndex = 8;
            this.bTxtMoney.TextAlign = System.Windows.Forms.HorizontalAlignment.Left;
            this.bTxtMoney.TextMarginBottom = 0;
            this.bTxtMoney.TextMarginLeft = 3;
            this.bTxtMoney.TextMarginTop = 0;
            this.bTxtMoney.TextPlaceholder = "Enter text";
            this.bTxtMoney.UseSystemPasswordChar = false;
            this.bTxtMoney.WordWrap = true;
            this.bTxtMoney.TextChange += new System.EventHandler(this.bTxtGiftCanGet_TextChange);
            this.bTxtMoney.Enter += new System.EventHandler(this.bTxtGiftCanGet_Enter);
            this.bTxtMoney.Leave += new System.EventHandler(this.bTxtGiftCanGet_Leave);
            // 
            // lbStatus
            // 
            this.lbStatus.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbStatus.ForeColor = System.Drawing.Color.DarkRed;
            this.lbStatus.Location = new System.Drawing.Point(362, 430);
            this.lbStatus.Name = "lbStatus";
            this.lbStatus.Size = new System.Drawing.Size(244, 40);
            this.lbStatus.TabIndex = 11;
            this.lbStatus.Text = "Đang xử lý vui lòng chờ.";
            this.lbStatus.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // timer_0
            // 
            this.timer_0.Interval = 1000;
            this.timer_0.Tick += new System.EventHandler(this.timer_0_Tick);
            // 
            // picGiftCanGet
            // 
            this.picGiftCanGet.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picGiftCanGet.Image = global::Properties.Resources.icon_money;
            this.picGiftCanGet.Location = new System.Drawing.Point(22, 387);
            this.picGiftCanGet.Name = "picGiftCanGet";
            this.picGiftCanGet.Size = new System.Drawing.Size(65, 32);
            this.picGiftCanGet.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.picGiftCanGet.TabIndex = 10;
            this.picGiftCanGet.TabStop = false;
            // 
            // bTxtGiftCanGet
            // 
            this.bTxtGiftCanGet.AcceptsReturn = false;
            this.bTxtGiftCanGet.AcceptsTab = false;
            this.bTxtGiftCanGet.AnimationSpeed = 200;
            this.bTxtGiftCanGet.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.None;
            this.bTxtGiftCanGet.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.None;
            this.bTxtGiftCanGet.BackColor = System.Drawing.Color.White;
            this.bTxtGiftCanGet.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("bTxtGiftCanGet.BackgroundImage")));
            this.bTxtGiftCanGet.BorderColorActive = System.Drawing.Color.DodgerBlue;
            this.bTxtGiftCanGet.BorderColorDisabled = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.bTxtGiftCanGet.BorderColorHover = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            this.bTxtGiftCanGet.BorderColorIdle = System.Drawing.Color.DimGray;
            this.bTxtGiftCanGet.BorderRadius = 1;
            this.bTxtGiftCanGet.BorderThickness = 0;
            this.bTxtGiftCanGet.CharacterCasing = System.Windows.Forms.CharacterCasing.Normal;
            this.bTxtGiftCanGet.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.bTxtGiftCanGet.DefaultFont = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bTxtGiftCanGet.DefaultText = "";
            this.bTxtGiftCanGet.Enabled = false;
            this.bTxtGiftCanGet.FillColor = System.Drawing.Color.White;
            this.bTxtGiftCanGet.ForeColor = System.Drawing.Color.ForestGreen;
            this.bTxtGiftCanGet.HideSelection = true;
            this.bTxtGiftCanGet.IconLeft = null;
            this.bTxtGiftCanGet.IconLeftCursor = System.Windows.Forms.Cursors.IBeam;
            this.bTxtGiftCanGet.IconPadding = 10;
            this.bTxtGiftCanGet.IconRight = null;
            this.bTxtGiftCanGet.IconRightCursor = System.Windows.Forms.Cursors.IBeam;
            this.bTxtGiftCanGet.Lines = new string[0];
            this.bTxtGiftCanGet.Location = new System.Drawing.Point(85, 387);
            this.bTxtGiftCanGet.MaxLength = 32767;
            this.bTxtGiftCanGet.MinimumSize = new System.Drawing.Size(1, 1);
            this.bTxtGiftCanGet.Modified = false;
            this.bTxtGiftCanGet.Multiline = false;
            this.bTxtGiftCanGet.Name = "bTxtGiftCanGet";
            stateProperties9.BorderColor = System.Drawing.Color.DodgerBlue;
            stateProperties9.FillColor = System.Drawing.Color.Empty;
            stateProperties9.ForeColor = System.Drawing.Color.Empty;
            stateProperties9.PlaceholderForeColor = System.Drawing.Color.Empty;
            this.bTxtGiftCanGet.OnActiveState = stateProperties9;
            stateProperties10.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            stateProperties10.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            stateProperties10.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            stateProperties10.PlaceholderForeColor = System.Drawing.Color.DarkGray;
            this.bTxtGiftCanGet.OnDisabledState = stateProperties10;
            stateProperties11.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            stateProperties11.FillColor = System.Drawing.Color.Empty;
            stateProperties11.ForeColor = System.Drawing.Color.Empty;
            stateProperties11.PlaceholderForeColor = System.Drawing.Color.Empty;
            this.bTxtGiftCanGet.OnHoverState = stateProperties11;
            stateProperties12.BorderColor = System.Drawing.Color.DimGray;
            stateProperties12.FillColor = System.Drawing.Color.White;
            stateProperties12.ForeColor = System.Drawing.Color.ForestGreen;
            stateProperties12.PlaceholderForeColor = System.Drawing.Color.Empty;
            this.bTxtGiftCanGet.OnIdleState = stateProperties12;
            this.bTxtGiftCanGet.Padding = new System.Windows.Forms.Padding(3);
            this.bTxtGiftCanGet.PasswordChar = '\0';
            this.bTxtGiftCanGet.PlaceholderForeColor = System.Drawing.Color.Silver;
            this.bTxtGiftCanGet.PlaceholderText = "Xu nhận được";
            this.bTxtGiftCanGet.ReadOnly = false;
            this.bTxtGiftCanGet.ScrollBars = System.Windows.Forms.ScrollBars.None;
            this.bTxtGiftCanGet.SelectedText = "";
            this.bTxtGiftCanGet.SelectionLength = 0;
            this.bTxtGiftCanGet.SelectionStart = 0;
            this.bTxtGiftCanGet.ShortcutsEnabled = true;
            this.bTxtGiftCanGet.Size = new System.Drawing.Size(887, 32);
            this.bTxtGiftCanGet.Style = Bunifu.UI.WinForms.BunifuTextBox._Style.Bunifu;
            this.bTxtGiftCanGet.TabIndex = 8;
            this.bTxtGiftCanGet.TextAlign = System.Windows.Forms.HorizontalAlignment.Left;
            this.bTxtGiftCanGet.TextMarginBottom = 0;
            this.bTxtGiftCanGet.TextMarginLeft = 3;
            this.bTxtGiftCanGet.TextMarginTop = 0;
            this.bTxtGiftCanGet.TextPlaceholder = "Xu nhận được";
            this.bTxtGiftCanGet.UseSystemPasswordChar = false;
            this.bTxtGiftCanGet.WordWrap = true;
            this.bTxtGiftCanGet.TextChange += new System.EventHandler(this.bTxtGiftCanGet_TextChange);
            this.bTxtGiftCanGet.Enter += new System.EventHandler(this.bTxtGiftCanGet_Enter);
            this.bTxtGiftCanGet.Leave += new System.EventHandler(this.bTxtGiftCanGet_Leave);
            // 
            // Exchange
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.BackgroundImage = global::Properties.Resources.bottm_bg;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.Controls.Add(this.lbStatus);
            this.Controls.Add(this.bTxtGiftCanGet);
            this.Controls.Add(this.bTxtMoney);
            this.Controls.Add(this.bTxtPassBag);
            this.Controls.Add(this.bDrdSelectChar);
            this.Controls.Add(this.picSelectChar);
            this.Controls.Add(this.picGiftCanGet);
            this.Controls.Add(this.bdrdSelectServer);
            this.Controls.Add(this.picMoney);
            this.Controls.Add(this.picSelectServer);
            this.Controls.Add(this.picPassBag);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.picBoxReset);
            this.Controls.Add(this.picBoxExchange);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.label1);
            this.Name = "Exchange";
            this.Size = new System.Drawing.Size(1000, 595);
            this.Load += new System.EventHandler(this.Exchange_Load);
            this.Enter += new System.EventHandler(this.Exchange_Enter);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxExchange)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxReset)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picSelectServer)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picPassBag)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picSelectChar)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picMoney)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picGiftCanGet)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

		}

		internal static void fmYYHy8embYKErrg6oy()
		{
		}

		internal static void uMGi2v8M7BpvWT5BVc1()
		{
		}

		internal static bool ao1lpK8LvTQplMPWA5V()
		{
			return R6P7vB86w4XMFyyNLO2 == null;
		}
	}
}
