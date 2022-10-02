using System;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Drawing;
using System.Globalization;
using System.Windows.Forms;
using Bunifu.UI.WinForms.BunifuButton;
using Launcher.Properties;
using Launcher.Statics;
using Launcher.UserControls;
using Properties;

namespace Launcher.Popup
{
	public class TopUpConfirm : Form
	{
		private readonly Main main_0 = Main.Instance;

		private readonly TopUp topUpForm;

		private string[] topUpParams;

		private BackgroundWorker backgroundWorker_0;

		private string resultText = "";

		private int int_0;

		private IContainer icontainer_0;

		private Timer waitTimer;

		private Panel panelComfirm;

		private Label lbPrice;

		private Label label3;

		private Label label2;

		private Label label1;

		private Panel panelSuccess;

		private BunifuButton btnCancel;

		private BunifuButton btnOk;

		private Label lbName;

		private PictureBox picLogo;

		private PictureBox pictureBox1;

		private BunifuButton btnSuccess;

		private Label labelResult;

		internal static TopUpConfirm nKWHr4unUZdmcWRRTPC;

		public TopUpConfirm(TopUp tapp, string[] datas)
		{
			InitializeComponent();
			topUpParams = datas;
			topUpForm = tapp;
			backgroundWorker_0 = new BackgroundWorker
			{
				WorkerReportsProgress = true,
				WorkerSupportsCancellation = true
			};
			backgroundWorker_0.DoWork += backgroundWorker_0_DoWork;
			backgroundWorker_0.RunWorkerCompleted += backgroundWorker_0_RunWorkerCompleted;
			backgroundWorker_0.ProgressChanged += backgroundWorker_0_ProgressChanged;
			btnOk.Height = (btnCancel.Height = (btnSuccess.Height = main_0.FixScaling(25)));
			base.Location = new Point(main_0.Location.X + main_0.Width / 2 - base.Width / 2 + main_0.panelLeftMenu.Width / 2, main_0.Location.Y + main_0.Height / 2 - base.Height / 2);
		}

		private void backgroundWorker_0_ProgressChanged(object sender, ProgressChangedEventArgs e)
		{
		}

		private void backgroundWorker_0_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
		{
			waitTimer.Stop();
			panelComfirm.Visible = false;
			panelSuccess.Location = new Point(panelComfirm.Location.X, panelComfirm.Location.Y);
			labelResult.Text = resultText;
		}

		private void backgroundWorker_0_DoWork(object sender, DoWorkEventArgs e)
		{
			ExchangeCash();
		}

		private void TopUpConfirm_Load(object sender, EventArgs e)
		{
			switch (topUpParams[0])
			{
			case "2":
				picLogo.Image = Resources.mobifone;
				lbName.Text = "Mobifone";
				break;
			case "3":
				picLogo.Image = Resources.vinaphone;
				lbName.Text = "Vinaphone";
				break;
			case "5":
				picLogo.Image = Resources.gate;
				lbName.Text = "FPT Gate";
				break;
			case "6":
				picLogo.Image = Resources.zing;
				lbName.Text = "Zing";
				break;
			case "4":
				picLogo.Image = Resources.vcoin;
				lbName.Text = "Vcoin";
				break;
			case "1":
				picLogo.Image = Resources.viettel;
				lbName.Text = "Viettel";
				break;
			}
			double num = double.Parse(topUpParams[3]);
			lbPrice.Text = num.ToString("n", CultureInfo.GetCultureInfo("vi-VN")).Replace(",00", "") + " VND";
		}

		private void ExchangeCash()
		{
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
					"cardType",
					topUpParams[0]
				},
				{
					"passCard",
					topUpParams[1]
				},
				{
					"serial",
					topUpParams[2]
				},
				{
					"money",
					topUpParams[3]
				},
				{
					"key",
					Util.MD5(LoginMgr.Username + LoginMgr.Password + Resources.PublicKey)
				}
			};
			string arg = ControlMgr.Post(DDTStaticFunc.Host + Resources.ExchangeCash, param);
			try
			{
				resultText = arg;
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception TopUpConfirm " + ex.Message, $"result:{arg},  \nerrors:{ex}");
			}
			finally
			{
				topUpForm.ReloadCash();
			}
		}

		private void btnCancel_Click(object sender, EventArgs e)
		{
			waitTimer.Stop();
			Close();
		}

		private void btnOk_Click(object sender, EventArgs e)
		{
			btnOk.Enabled = false;
			btnCancel.Enabled = false;
			waitTimer.Start();
		}

		private void waitTimer_Tick(object sender, EventArgs e)
		{
			int_0++;
			btnOk.Text = $"Xác nhận ({int_0})";
			if (int_0 == 3 && !backgroundWorker_0.IsBusy)
			{
				backgroundWorker_0.RunWorkerAsync();
			}
		}

		private void btnSuccess_Click(object sender, EventArgs e)
		{
			btnCancel_Click(null, null);
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Launcher.Popup.TopUpConfirm));
			Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
			Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges2 = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
			Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges3 = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
			waitTimer = new System.Windows.Forms.Timer(icontainer_0);
			panelComfirm = new System.Windows.Forms.Panel();
			btnCancel = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
			btnOk = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
			lbName = new System.Windows.Forms.Label();
			picLogo = new System.Windows.Forms.PictureBox();
			lbPrice = new System.Windows.Forms.Label();
			label3 = new System.Windows.Forms.Label();
			label2 = new System.Windows.Forms.Label();
			label1 = new System.Windows.Forms.Label();
			panelSuccess = new System.Windows.Forms.Panel();
			pictureBox1 = new System.Windows.Forms.PictureBox();
			btnSuccess = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
			labelResult = new System.Windows.Forms.Label();
			panelComfirm.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picLogo).BeginInit();
			panelSuccess.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)pictureBox1).BeginInit();
			SuspendLayout();
			waitTimer.Interval = 1000;
			waitTimer.Tick += new System.EventHandler(waitTimer_Tick);
			panelComfirm.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
			panelComfirm.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			panelComfirm.Controls.Add(btnCancel);
			panelComfirm.Controls.Add(btnOk);
			panelComfirm.Controls.Add(lbName);
			panelComfirm.Controls.Add(picLogo);
			panelComfirm.Controls.Add(lbPrice);
			panelComfirm.Controls.Add(label3);
			panelComfirm.Controls.Add(label2);
			panelComfirm.Controls.Add(label1);
			panelComfirm.Location = new System.Drawing.Point(0, 0);
			panelComfirm.Name = "panelComfirm";
			panelComfirm.Size = new System.Drawing.Size(357, 180);
			panelComfirm.TabIndex = 0;
			btnCancel.AllowToggling = false;
			btnCancel.AnimationSpeed = 200;
			btnCancel.AutoGenerateColors = false;
			btnCancel.AutoSizeLeftIcon = true;
			btnCancel.AutoSizeRightIcon = true;
			btnCancel.BackColor = System.Drawing.Color.Transparent;
			btnCancel.BackColor1 = System.Drawing.Color.DodgerBlue;
			btnCancel.BackgroundImage = (System.Drawing.Image)resources.GetObject("btnCancel.BackgroundImage");
			btnCancel.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnCancel.ButtonText = "Huỷ";
			btnCancel.ButtonTextMarginLeft = 0;
			btnCancel.ColorContrastOnClick = 45;
			btnCancel.ColorContrastOnHover = 45;
			btnCancel.Cursor = System.Windows.Forms.Cursors.Default;
			borderEdges.BottomLeft = true;
			borderEdges.BottomRight = true;
			borderEdges.TopLeft = true;
			borderEdges.TopRight = true;
			btnCancel.CustomizableEdges = borderEdges;
			btnCancel.DialogResult = System.Windows.Forms.DialogResult.None;
			btnCancel.DisabledBorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			btnCancel.DisabledFillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			btnCancel.DisabledForecolor = System.Drawing.Color.FromArgb(168, 160, 168);
			btnCancel.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
			btnCancel.Font = new System.Drawing.Font("Segoe UI", 9f);
			btnCancel.ForeColor = System.Drawing.Color.White;
			btnCancel.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
			btnCancel.IconLeftCursor = System.Windows.Forms.Cursors.Default;
			btnCancel.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
			btnCancel.IconMarginLeft = 11;
			btnCancel.IconPadding = 10;
			btnCancel.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
			btnCancel.IconRightCursor = System.Windows.Forms.Cursors.Default;
			btnCancel.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
			btnCancel.IconSize = 25;
			btnCancel.IdleBorderColor = System.Drawing.Color.DodgerBlue;
			btnCancel.IdleBorderRadius = 1;
			btnCancel.IdleBorderThickness = 1;
			btnCancel.IdleFillColor = System.Drawing.Color.DodgerBlue;
			btnCancel.IdleIconLeftImage = null;
			btnCancel.IdleIconRightImage = null;
			btnCancel.IndicateFocus = false;
			btnCancel.Location = new System.Drawing.Point(168, 138);
			btnCancel.Name = "btnCancel";
			btnCancel.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			btnCancel.OnDisabledState.BorderRadius = 1;
			btnCancel.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnCancel.OnDisabledState.BorderThickness = 1;
			btnCancel.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			btnCancel.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(168, 160, 168);
			btnCancel.OnDisabledState.IconLeftImage = null;
			btnCancel.OnDisabledState.IconRightImage = null;
			btnCancel.onHoverState.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			btnCancel.onHoverState.BorderRadius = 1;
			btnCancel.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnCancel.onHoverState.BorderThickness = 1;
			btnCancel.onHoverState.FillColor = System.Drawing.Color.FromArgb(105, 181, 255);
			btnCancel.onHoverState.ForeColor = System.Drawing.Color.White;
			btnCancel.onHoverState.IconLeftImage = null;
			btnCancel.onHoverState.IconRightImage = null;
			btnCancel.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
			btnCancel.OnIdleState.BorderRadius = 1;
			btnCancel.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnCancel.OnIdleState.BorderThickness = 1;
			btnCancel.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
			btnCancel.OnIdleState.ForeColor = System.Drawing.Color.White;
			btnCancel.OnIdleState.IconLeftImage = null;
			btnCancel.OnIdleState.IconRightImage = null;
			btnCancel.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(40, 96, 144);
			btnCancel.OnPressedState.BorderRadius = 1;
			btnCancel.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnCancel.OnPressedState.BorderThickness = 1;
			btnCancel.OnPressedState.FillColor = System.Drawing.Color.FromArgb(40, 96, 144);
			btnCancel.OnPressedState.ForeColor = System.Drawing.Color.White;
			btnCancel.OnPressedState.IconLeftImage = null;
			btnCancel.OnPressedState.IconRightImage = null;
			btnCancel.Size = new System.Drawing.Size(86, 25);
			btnCancel.TabIndex = 4;
			btnCancel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			btnCancel.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
			btnCancel.TextMarginLeft = 0;
			btnCancel.TextPadding = new System.Windows.Forms.Padding(0);
			btnCancel.UseDefaultRadiusAndThickness = true;
			btnCancel.Click += new System.EventHandler(btnCancel_Click);
			btnOk.AllowToggling = false;
			btnOk.AnimationSpeed = 200;
			btnOk.AutoGenerateColors = false;
			btnOk.AutoSizeLeftIcon = true;
			btnOk.AutoSizeRightIcon = true;
			btnOk.BackColor = System.Drawing.Color.Transparent;
			btnOk.BackColor1 = System.Drawing.Color.DodgerBlue;
			btnOk.BackgroundImage = (System.Drawing.Image)resources.GetObject("btnOk.BackgroundImage");
			btnOk.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnOk.ButtonText = "Xác nhận";
			btnOk.ButtonTextMarginLeft = 0;
			btnOk.ColorContrastOnClick = 45;
			btnOk.ColorContrastOnHover = 45;
			btnOk.Cursor = System.Windows.Forms.Cursors.Default;
			borderEdges2.BottomLeft = true;
			borderEdges2.BottomRight = true;
			borderEdges2.TopLeft = true;
			borderEdges2.TopRight = true;
			btnOk.CustomizableEdges = borderEdges2;
			btnOk.DialogResult = System.Windows.Forms.DialogResult.None;
			btnOk.DisabledBorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			btnOk.DisabledFillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			btnOk.DisabledForecolor = System.Drawing.Color.FromArgb(168, 160, 168);
			btnOk.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
			btnOk.Font = new System.Drawing.Font("Segoe UI", 9f);
			btnOk.ForeColor = System.Drawing.Color.White;
			btnOk.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
			btnOk.IconLeftCursor = System.Windows.Forms.Cursors.Default;
			btnOk.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
			btnOk.IconMarginLeft = 11;
			btnOk.IconPadding = 10;
			btnOk.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
			btnOk.IconRightCursor = System.Windows.Forms.Cursors.Default;
			btnOk.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
			btnOk.IconSize = 25;
			btnOk.IdleBorderColor = System.Drawing.Color.DodgerBlue;
			btnOk.IdleBorderRadius = 1;
			btnOk.IdleBorderThickness = 1;
			btnOk.IdleFillColor = System.Drawing.Color.DodgerBlue;
			btnOk.IdleIconLeftImage = null;
			btnOk.IdleIconRightImage = null;
			btnOk.IndicateFocus = false;
			btnOk.Location = new System.Drawing.Point(74, 138);
			btnOk.Name = "btnOk";
			btnOk.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			btnOk.OnDisabledState.BorderRadius = 1;
			btnOk.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnOk.OnDisabledState.BorderThickness = 1;
			btnOk.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			btnOk.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(168, 160, 168);
			btnOk.OnDisabledState.IconLeftImage = null;
			btnOk.OnDisabledState.IconRightImage = null;
			btnOk.onHoverState.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			btnOk.onHoverState.BorderRadius = 1;
			btnOk.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnOk.onHoverState.BorderThickness = 1;
			btnOk.onHoverState.FillColor = System.Drawing.Color.FromArgb(105, 181, 255);
			btnOk.onHoverState.ForeColor = System.Drawing.Color.White;
			btnOk.onHoverState.IconLeftImage = null;
			btnOk.onHoverState.IconRightImage = null;
			btnOk.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
			btnOk.OnIdleState.BorderRadius = 1;
			btnOk.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnOk.OnIdleState.BorderThickness = 1;
			btnOk.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
			btnOk.OnIdleState.ForeColor = System.Drawing.Color.White;
			btnOk.OnIdleState.IconLeftImage = null;
			btnOk.OnIdleState.IconRightImage = null;
			btnOk.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(40, 96, 144);
			btnOk.OnPressedState.BorderRadius = 1;
			btnOk.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnOk.OnPressedState.BorderThickness = 1;
			btnOk.OnPressedState.FillColor = System.Drawing.Color.FromArgb(40, 96, 144);
			btnOk.OnPressedState.ForeColor = System.Drawing.Color.White;
			btnOk.OnPressedState.IconLeftImage = null;
			btnOk.OnPressedState.IconRightImage = null;
			btnOk.Size = new System.Drawing.Size(86, 25);
			btnOk.TabIndex = 4;
			btnOk.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			btnOk.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
			btnOk.TextMarginLeft = 0;
			btnOk.TextPadding = new System.Windows.Forms.Padding(0);
			btnOk.UseDefaultRadiusAndThickness = true;
			btnOk.Click += new System.EventHandler(btnOk_Click);
			lbName.AutoSize = true;
			lbName.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			lbName.Location = new System.Drawing.Point(168, 56);
			lbName.Name = "lbName";
			lbName.Size = new System.Drawing.Size(72, 25);
			lbName.TabIndex = 3;
			lbName.Text = "Viettel";
			picLogo.Image = Resources.viettel;
			picLogo.Location = new System.Drawing.Point(79, 49);
			picLogo.Name = "picLogo";
			picLogo.Size = new System.Drawing.Size(80, 40);
			picLogo.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picLogo.TabIndex = 2;
			picLogo.TabStop = false;
			lbPrice.AutoSize = true;
			lbPrice.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			lbPrice.ForeColor = System.Drawing.Color.DarkGreen;
			lbPrice.Location = new System.Drawing.Point(85, 100);
			lbPrice.Name = "lbPrice";
			lbPrice.Size = new System.Drawing.Size(88, 16);
			lbPrice.TabIndex = 1;
			lbPrice.Text = "10.000 VND";
			label3.AutoSize = true;
			label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			label3.ForeColor = System.Drawing.Color.DimGray;
			label3.Location = new System.Drawing.Point(6, 100);
			label3.Name = "label3";
			label3.Size = new System.Drawing.Size(75, 16);
			label3.TabIndex = 1;
			label3.Text = "Mệnh giá:";
			label2.AutoSize = true;
			label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			label2.ForeColor = System.Drawing.Color.DimGray;
			label2.Location = new System.Drawing.Point(6, 62);
			label2.Name = "label2";
			label2.Size = new System.Drawing.Size(67, 16);
			label2.TabIndex = 1;
			label2.Text = "Loại thẻ ";
			label1.AutoSize = true;
			label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label1.ForeColor = System.Drawing.Color.DarkRed;
			label1.Location = new System.Drawing.Point(70, 8);
			label1.Name = "label1";
			label1.Size = new System.Drawing.Size(210, 24);
			label1.TabIndex = 0;
			label1.Text = "XÁC NHẬN GIAO DỊCH";
			panelSuccess.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
			panelSuccess.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			panelSuccess.Controls.Add(pictureBox1);
			panelSuccess.Controls.Add(btnSuccess);
			panelSuccess.Controls.Add(labelResult);
			panelSuccess.Location = new System.Drawing.Point(0, 250);
			panelSuccess.Name = "panelSuccess";
			panelSuccess.Size = new System.Drawing.Size(357, 180);
			panelSuccess.TabIndex = 0;
			pictureBox1.Image = Resources.check;
			pictureBox1.Location = new System.Drawing.Point(122, 56);
			pictureBox1.Name = "pictureBox1";
			pictureBox1.Size = new System.Drawing.Size(99, 83);
			pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			pictureBox1.TabIndex = 6;
			pictureBox1.TabStop = false;
			btnSuccess.AllowToggling = false;
			btnSuccess.AnimationSpeed = 200;
			btnSuccess.AutoGenerateColors = false;
			btnSuccess.AutoSizeLeftIcon = true;
			btnSuccess.AutoSizeRightIcon = true;
			btnSuccess.BackColor = System.Drawing.Color.Transparent;
			btnSuccess.BackColor1 = System.Drawing.Color.DodgerBlue;
			btnSuccess.BackgroundImage = (System.Drawing.Image)resources.GetObject("btnSuccess.BackgroundImage");
			btnSuccess.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSuccess.ButtonText = "OK";
			btnSuccess.ButtonTextMarginLeft = 0;
			btnSuccess.ColorContrastOnClick = 45;
			btnSuccess.ColorContrastOnHover = 45;
			btnSuccess.Cursor = System.Windows.Forms.Cursors.Default;
			borderEdges3.BottomLeft = true;
			borderEdges3.BottomRight = true;
			borderEdges3.TopLeft = true;
			borderEdges3.TopRight = true;
			btnSuccess.CustomizableEdges = borderEdges3;
			btnSuccess.DialogResult = System.Windows.Forms.DialogResult.None;
			btnSuccess.DisabledBorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			btnSuccess.DisabledFillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			btnSuccess.DisabledForecolor = System.Drawing.Color.FromArgb(168, 160, 168);
			btnSuccess.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
			btnSuccess.Font = new System.Drawing.Font("Segoe UI", 9f);
			btnSuccess.ForeColor = System.Drawing.Color.White;
			btnSuccess.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
			btnSuccess.IconLeftCursor = System.Windows.Forms.Cursors.Default;
			btnSuccess.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
			btnSuccess.IconMarginLeft = 11;
			btnSuccess.IconPadding = 10;
			btnSuccess.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
			btnSuccess.IconRightCursor = System.Windows.Forms.Cursors.Default;
			btnSuccess.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
			btnSuccess.IconSize = 25;
			btnSuccess.IdleBorderColor = System.Drawing.Color.DodgerBlue;
			btnSuccess.IdleBorderRadius = 1;
			btnSuccess.IdleBorderThickness = 1;
			btnSuccess.IdleFillColor = System.Drawing.Color.DodgerBlue;
			btnSuccess.IdleIconLeftImage = null;
			btnSuccess.IdleIconRightImage = null;
			btnSuccess.IndicateFocus = false;
			btnSuccess.Location = new System.Drawing.Point(128, 145);
			btnSuccess.Name = "btnSuccess";
			btnSuccess.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			btnSuccess.OnDisabledState.BorderRadius = 1;
			btnSuccess.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSuccess.OnDisabledState.BorderThickness = 1;
			btnSuccess.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			btnSuccess.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(168, 160, 168);
			btnSuccess.OnDisabledState.IconLeftImage = null;
			btnSuccess.OnDisabledState.IconRightImage = null;
			btnSuccess.onHoverState.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			btnSuccess.onHoverState.BorderRadius = 1;
			btnSuccess.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSuccess.onHoverState.BorderThickness = 1;
			btnSuccess.onHoverState.FillColor = System.Drawing.Color.FromArgb(105, 181, 255);
			btnSuccess.onHoverState.ForeColor = System.Drawing.Color.White;
			btnSuccess.onHoverState.IconLeftImage = null;
			btnSuccess.onHoverState.IconRightImage = null;
			btnSuccess.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
			btnSuccess.OnIdleState.BorderRadius = 1;
			btnSuccess.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSuccess.OnIdleState.BorderThickness = 1;
			btnSuccess.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
			btnSuccess.OnIdleState.ForeColor = System.Drawing.Color.White;
			btnSuccess.OnIdleState.IconLeftImage = null;
			btnSuccess.OnIdleState.IconRightImage = null;
			btnSuccess.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(40, 96, 144);
			btnSuccess.OnPressedState.BorderRadius = 1;
			btnSuccess.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			btnSuccess.OnPressedState.BorderThickness = 1;
			btnSuccess.OnPressedState.FillColor = System.Drawing.Color.FromArgb(40, 96, 144);
			btnSuccess.OnPressedState.ForeColor = System.Drawing.Color.White;
			btnSuccess.OnPressedState.IconLeftImage = null;
			btnSuccess.OnPressedState.IconRightImage = null;
			btnSuccess.Size = new System.Drawing.Size(86, 25);
			btnSuccess.TabIndex = 5;
			btnSuccess.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			btnSuccess.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
			btnSuccess.TextMarginLeft = 0;
			btnSuccess.TextPadding = new System.Windows.Forms.Padding(0);
			btnSuccess.UseDefaultRadiusAndThickness = true;
			btnSuccess.Click += new System.EventHandler(btnSuccess_Click);
			labelResult.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			labelResult.ForeColor = System.Drawing.Color.DarkRed;
			labelResult.Location = new System.Drawing.Point(51, 7);
			labelResult.Name = "labelResult";
			labelResult.Size = new System.Drawing.Size(252, 69);
			labelResult.TabIndex = 1;
			labelResult.Text = "Đang xử lý vui lòng đợi! ";
			labelResult.TextAlign = System.Drawing.ContentAlignment.TopCenter;
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			BackColor = System.Drawing.Color.White;
			base.ClientSize = new System.Drawing.Size(357, 180);
			base.Controls.Add(panelSuccess);
			base.Controls.Add(panelComfirm);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Name = "TopUpConfirm";
			base.ShowIcon = false;
			base.ShowInTaskbar = false;
			base.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
			Text = "TopUpConfirm";
			base.Load += new System.EventHandler(TopUpConfirm_Load);
			panelComfirm.ResumeLayout(false);
			panelComfirm.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picLogo).EndInit();
			panelSuccess.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)pictureBox1).EndInit();
			ResumeLayout(false);
		}

		internal static bool erMYmgu9fLG1RfqvaIc()
		{
			return nKWHr4unUZdmcWRRTPC == null;
		}
	}
}
