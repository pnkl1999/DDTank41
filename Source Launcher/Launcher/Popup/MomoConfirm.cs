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
	public class MomoConfirm : Form
	{
		private readonly Main main_0 = Main.Instance;

		private readonly PaymentMomo paymentMomo;

		private string[] paymentMomoParams;

		private BackgroundWorker backgroundWorker_0;

		private string resultText = "";

		private int int_0;

		private IContainer icontainer_0;

		private Timer waitTimer;

		private Panel panelComfirm;

		private Label label3;

		private Label label2;

		private Label label1;

		private Panel panelSuccess;

		private BunifuButton btnCancel;

		private BunifuButton btnOk;

		private Label lbName;

		private PictureBox pictureBox1;

		private BunifuButton btnSuccess;

		private Label labelResult;
        private IContainer components;
        private Label lbPrice;
        internal static TopUpConfirm nKWHr4unUZdmcWRRTPC;

		public MomoConfirm(PaymentMomo tapp, string[] datas)
		{
			InitializeComponent();
			paymentMomoParams = datas;
			paymentMomo = tapp;
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
			PaymentMomo();
		}

		private void TopUpConfirm_Load(object sender, EventArgs e)
		{
			lbPrice.Text = paymentMomoParams[0];
		}

		private void PaymentMomo()
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
                    "tranId",
					paymentMomoParams[0]
				},
				{
					"key",
					Util.MD5(LoginMgr.Username + LoginMgr.Password + Resources.PublicKey)
				}
			};
			string arg = ControlMgr.Post(DDTStaticFunc.Host + Resources.RechargeMomo, param);
			try
			{
				resultText = arg;
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception MomoConfirm " + ex.Message, $"result:{arg},  \nerrors:{ex}");
			}
			finally
			{
				paymentMomo.ReloadCash();
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MomoConfirm));
            Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges4 = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
            Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges5 = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
            Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges6 = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
            this.waitTimer = new System.Windows.Forms.Timer(this.components);
            this.panelComfirm = new System.Windows.Forms.Panel();
            this.btnCancel = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
            this.btnOk = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
            this.lbName = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.panelSuccess = new System.Windows.Forms.Panel();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.btnSuccess = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
            this.labelResult = new System.Windows.Forms.Label();
            this.lbPrice = new System.Windows.Forms.Label();
            this.panelComfirm.SuspendLayout();
            this.panelSuccess.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // waitTimer
            // 
            this.waitTimer.Interval = 1000;
            this.waitTimer.Tick += new System.EventHandler(this.waitTimer_Tick);
            // 
            // panelComfirm
            // 
            this.panelComfirm.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.panelComfirm.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panelComfirm.Controls.Add(this.btnCancel);
            this.panelComfirm.Controls.Add(this.btnOk);
            this.panelComfirm.Controls.Add(this.lbName);
            this.panelComfirm.Controls.Add(this.lbPrice);
            this.panelComfirm.Controls.Add(this.label3);
            this.panelComfirm.Controls.Add(this.label2);
            this.panelComfirm.Controls.Add(this.label1);
            this.panelComfirm.Location = new System.Drawing.Point(0, 0);
            this.panelComfirm.Name = "panelComfirm";
            this.panelComfirm.Size = new System.Drawing.Size(357, 180);
            this.panelComfirm.TabIndex = 0;
            // 
            // btnCancel
            // 
            this.btnCancel.AllowToggling = false;
            this.btnCancel.AnimationSpeed = 200;
            this.btnCancel.AutoGenerateColors = false;
            this.btnCancel.AutoSizeLeftIcon = true;
            this.btnCancel.AutoSizeRightIcon = true;
            this.btnCancel.BackColor = System.Drawing.Color.Transparent;
            this.btnCancel.BackColor1 = System.Drawing.Color.DodgerBlue;
            this.btnCancel.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnCancel.BackgroundImage")));
            this.btnCancel.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnCancel.ButtonText = "Huỷ";
            this.btnCancel.ButtonTextMarginLeft = 0;
            this.btnCancel.ColorContrastOnClick = 45;
            this.btnCancel.ColorContrastOnHover = 45;
            this.btnCancel.Cursor = System.Windows.Forms.Cursors.Default;
            borderEdges4.BottomLeft = true;
            borderEdges4.BottomRight = true;
            borderEdges4.TopLeft = true;
            borderEdges4.TopRight = true;
            this.btnCancel.CustomizableEdges = borderEdges4;
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.None;
            this.btnCancel.DisabledBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.btnCancel.DisabledFillColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.btnCancel.DisabledForecolor = System.Drawing.Color.FromArgb(((int)(((byte)(168)))), ((int)(((byte)(160)))), ((int)(((byte)(168)))));
            this.btnCancel.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
            this.btnCancel.Font = new System.Drawing.Font("Segoe UI", 9F);
            this.btnCancel.ForeColor = System.Drawing.Color.White;
            this.btnCancel.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnCancel.IconLeftCursor = System.Windows.Forms.Cursors.Default;
            this.btnCancel.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
            this.btnCancel.IconMarginLeft = 11;
            this.btnCancel.IconPadding = 10;
            this.btnCancel.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.btnCancel.IconRightCursor = System.Windows.Forms.Cursors.Default;
            this.btnCancel.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
            this.btnCancel.IconSize = 25;
            this.btnCancel.IdleBorderColor = System.Drawing.Color.DodgerBlue;
            this.btnCancel.IdleBorderRadius = 1;
            this.btnCancel.IdleBorderThickness = 1;
            this.btnCancel.IdleFillColor = System.Drawing.Color.DodgerBlue;
            this.btnCancel.IdleIconLeftImage = null;
            this.btnCancel.IdleIconRightImage = null;
            this.btnCancel.IndicateFocus = false;
            this.btnCancel.Location = new System.Drawing.Point(168, 138);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.btnCancel.OnDisabledState.BorderRadius = 1;
            this.btnCancel.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnCancel.OnDisabledState.BorderThickness = 1;
            this.btnCancel.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.btnCancel.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(168)))), ((int)(((byte)(160)))), ((int)(((byte)(168)))));
            this.btnCancel.OnDisabledState.IconLeftImage = null;
            this.btnCancel.OnDisabledState.IconRightImage = null;
            this.btnCancel.onHoverState.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            this.btnCancel.onHoverState.BorderRadius = 1;
            this.btnCancel.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnCancel.onHoverState.BorderThickness = 1;
            this.btnCancel.onHoverState.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            this.btnCancel.onHoverState.ForeColor = System.Drawing.Color.White;
            this.btnCancel.onHoverState.IconLeftImage = null;
            this.btnCancel.onHoverState.IconRightImage = null;
            this.btnCancel.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
            this.btnCancel.OnIdleState.BorderRadius = 1;
            this.btnCancel.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnCancel.OnIdleState.BorderThickness = 1;
            this.btnCancel.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
            this.btnCancel.OnIdleState.ForeColor = System.Drawing.Color.White;
            this.btnCancel.OnIdleState.IconLeftImage = null;
            this.btnCancel.OnIdleState.IconRightImage = null;
            this.btnCancel.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(96)))), ((int)(((byte)(144)))));
            this.btnCancel.OnPressedState.BorderRadius = 1;
            this.btnCancel.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnCancel.OnPressedState.BorderThickness = 1;
            this.btnCancel.OnPressedState.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(96)))), ((int)(((byte)(144)))));
            this.btnCancel.OnPressedState.ForeColor = System.Drawing.Color.White;
            this.btnCancel.OnPressedState.IconLeftImage = null;
            this.btnCancel.OnPressedState.IconRightImage = null;
            this.btnCancel.Size = new System.Drawing.Size(86, 25);
            this.btnCancel.TabIndex = 4;
            this.btnCancel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.btnCancel.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
            this.btnCancel.TextMarginLeft = 0;
            this.btnCancel.TextPadding = new System.Windows.Forms.Padding(0);
            this.btnCancel.UseDefaultRadiusAndThickness = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnOk
            // 
            this.btnOk.AllowToggling = false;
            this.btnOk.AnimationSpeed = 200;
            this.btnOk.AutoGenerateColors = false;
            this.btnOk.AutoSizeLeftIcon = true;
            this.btnOk.AutoSizeRightIcon = true;
            this.btnOk.BackColor = System.Drawing.Color.Transparent;
            this.btnOk.BackColor1 = System.Drawing.Color.DodgerBlue;
            this.btnOk.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnOk.BackgroundImage")));
            this.btnOk.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnOk.ButtonText = "Xác nhận";
            this.btnOk.ButtonTextMarginLeft = 0;
            this.btnOk.ColorContrastOnClick = 45;
            this.btnOk.ColorContrastOnHover = 45;
            this.btnOk.Cursor = System.Windows.Forms.Cursors.Default;
            borderEdges5.BottomLeft = true;
            borderEdges5.BottomRight = true;
            borderEdges5.TopLeft = true;
            borderEdges5.TopRight = true;
            this.btnOk.CustomizableEdges = borderEdges5;
            this.btnOk.DialogResult = System.Windows.Forms.DialogResult.None;
            this.btnOk.DisabledBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.btnOk.DisabledFillColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.btnOk.DisabledForecolor = System.Drawing.Color.FromArgb(((int)(((byte)(168)))), ((int)(((byte)(160)))), ((int)(((byte)(168)))));
            this.btnOk.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
            this.btnOk.Font = new System.Drawing.Font("Segoe UI", 9F);
            this.btnOk.ForeColor = System.Drawing.Color.White;
            this.btnOk.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnOk.IconLeftCursor = System.Windows.Forms.Cursors.Default;
            this.btnOk.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
            this.btnOk.IconMarginLeft = 11;
            this.btnOk.IconPadding = 10;
            this.btnOk.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.btnOk.IconRightCursor = System.Windows.Forms.Cursors.Default;
            this.btnOk.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
            this.btnOk.IconSize = 25;
            this.btnOk.IdleBorderColor = System.Drawing.Color.DodgerBlue;
            this.btnOk.IdleBorderRadius = 1;
            this.btnOk.IdleBorderThickness = 1;
            this.btnOk.IdleFillColor = System.Drawing.Color.DodgerBlue;
            this.btnOk.IdleIconLeftImage = null;
            this.btnOk.IdleIconRightImage = null;
            this.btnOk.IndicateFocus = false;
            this.btnOk.Location = new System.Drawing.Point(74, 138);
            this.btnOk.Name = "btnOk";
            this.btnOk.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.btnOk.OnDisabledState.BorderRadius = 1;
            this.btnOk.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnOk.OnDisabledState.BorderThickness = 1;
            this.btnOk.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.btnOk.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(168)))), ((int)(((byte)(160)))), ((int)(((byte)(168)))));
            this.btnOk.OnDisabledState.IconLeftImage = null;
            this.btnOk.OnDisabledState.IconRightImage = null;
            this.btnOk.onHoverState.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            this.btnOk.onHoverState.BorderRadius = 1;
            this.btnOk.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnOk.onHoverState.BorderThickness = 1;
            this.btnOk.onHoverState.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            this.btnOk.onHoverState.ForeColor = System.Drawing.Color.White;
            this.btnOk.onHoverState.IconLeftImage = null;
            this.btnOk.onHoverState.IconRightImage = null;
            this.btnOk.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
            this.btnOk.OnIdleState.BorderRadius = 1;
            this.btnOk.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnOk.OnIdleState.BorderThickness = 1;
            this.btnOk.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
            this.btnOk.OnIdleState.ForeColor = System.Drawing.Color.White;
            this.btnOk.OnIdleState.IconLeftImage = null;
            this.btnOk.OnIdleState.IconRightImage = null;
            this.btnOk.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(96)))), ((int)(((byte)(144)))));
            this.btnOk.OnPressedState.BorderRadius = 1;
            this.btnOk.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnOk.OnPressedState.BorderThickness = 1;
            this.btnOk.OnPressedState.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(96)))), ((int)(((byte)(144)))));
            this.btnOk.OnPressedState.ForeColor = System.Drawing.Color.White;
            this.btnOk.OnPressedState.IconLeftImage = null;
            this.btnOk.OnPressedState.IconRightImage = null;
            this.btnOk.Size = new System.Drawing.Size(86, 25);
            this.btnOk.TabIndex = 4;
            this.btnOk.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.btnOk.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
            this.btnOk.TextMarginLeft = 0;
            this.btnOk.TextPadding = new System.Windows.Forms.Padding(0);
            this.btnOk.UseDefaultRadiusAndThickness = true;
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // lbName
            // 
            this.lbName.AutoSize = true;
            this.lbName.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbName.Location = new System.Drawing.Point(117, 55);
            this.lbName.Name = "lbName";
            this.lbName.Size = new System.Drawing.Size(80, 25);
            this.lbName.TabIndex = 3;
            this.lbName.Text = "MOMO";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.DimGray;
            this.label3.Location = new System.Drawing.Point(6, 100);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(101, 16);
            this.label3.TabIndex = 1;
            this.label3.Text = "Mã giao dịch:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.DimGray;
            this.label2.Location = new System.Drawing.Point(6, 62);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(114, 16);
            this.label2.TabIndex = 1;
            this.label2.Text = "Loại giao dịch: ";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.DarkRed;
            this.label1.Location = new System.Drawing.Point(70, 8);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(210, 24);
            this.label1.TabIndex = 0;
            this.label1.Text = "XÁC NHẬN GIAO DỊCH";
            // 
            // panelSuccess
            // 
            this.panelSuccess.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.panelSuccess.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panelSuccess.Controls.Add(this.pictureBox1);
            this.panelSuccess.Controls.Add(this.btnSuccess);
            this.panelSuccess.Controls.Add(this.labelResult);
            this.panelSuccess.Location = new System.Drawing.Point(0, 250);
            this.panelSuccess.Name = "panelSuccess";
            this.panelSuccess.Size = new System.Drawing.Size(357, 180);
            this.panelSuccess.TabIndex = 0;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Location = new System.Drawing.Point(122, 56);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(99, 83);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox1.TabIndex = 6;
            this.pictureBox1.TabStop = false;
            // 
            // btnSuccess
            // 
            this.btnSuccess.AllowToggling = false;
            this.btnSuccess.AnimationSpeed = 200;
            this.btnSuccess.AutoGenerateColors = false;
            this.btnSuccess.AutoSizeLeftIcon = true;
            this.btnSuccess.AutoSizeRightIcon = true;
            this.btnSuccess.BackColor = System.Drawing.Color.Transparent;
            this.btnSuccess.BackColor1 = System.Drawing.Color.DodgerBlue;
            this.btnSuccess.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnSuccess.BackgroundImage")));
            this.btnSuccess.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnSuccess.ButtonText = "OK";
            this.btnSuccess.ButtonTextMarginLeft = 0;
            this.btnSuccess.ColorContrastOnClick = 45;
            this.btnSuccess.ColorContrastOnHover = 45;
            this.btnSuccess.Cursor = System.Windows.Forms.Cursors.Default;
            borderEdges6.BottomLeft = true;
            borderEdges6.BottomRight = true;
            borderEdges6.TopLeft = true;
            borderEdges6.TopRight = true;
            this.btnSuccess.CustomizableEdges = borderEdges6;
            this.btnSuccess.DialogResult = System.Windows.Forms.DialogResult.None;
            this.btnSuccess.DisabledBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.btnSuccess.DisabledFillColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.btnSuccess.DisabledForecolor = System.Drawing.Color.FromArgb(((int)(((byte)(168)))), ((int)(((byte)(160)))), ((int)(((byte)(168)))));
            this.btnSuccess.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
            this.btnSuccess.Font = new System.Drawing.Font("Segoe UI", 9F);
            this.btnSuccess.ForeColor = System.Drawing.Color.White;
            this.btnSuccess.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnSuccess.IconLeftCursor = System.Windows.Forms.Cursors.Default;
            this.btnSuccess.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
            this.btnSuccess.IconMarginLeft = 11;
            this.btnSuccess.IconPadding = 10;
            this.btnSuccess.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.btnSuccess.IconRightCursor = System.Windows.Forms.Cursors.Default;
            this.btnSuccess.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
            this.btnSuccess.IconSize = 25;
            this.btnSuccess.IdleBorderColor = System.Drawing.Color.DodgerBlue;
            this.btnSuccess.IdleBorderRadius = 1;
            this.btnSuccess.IdleBorderThickness = 1;
            this.btnSuccess.IdleFillColor = System.Drawing.Color.DodgerBlue;
            this.btnSuccess.IdleIconLeftImage = null;
            this.btnSuccess.IdleIconRightImage = null;
            this.btnSuccess.IndicateFocus = false;
            this.btnSuccess.Location = new System.Drawing.Point(128, 145);
            this.btnSuccess.Name = "btnSuccess";
            this.btnSuccess.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.btnSuccess.OnDisabledState.BorderRadius = 1;
            this.btnSuccess.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnSuccess.OnDisabledState.BorderThickness = 1;
            this.btnSuccess.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.btnSuccess.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(168)))), ((int)(((byte)(160)))), ((int)(((byte)(168)))));
            this.btnSuccess.OnDisabledState.IconLeftImage = null;
            this.btnSuccess.OnDisabledState.IconRightImage = null;
            this.btnSuccess.onHoverState.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            this.btnSuccess.onHoverState.BorderRadius = 1;
            this.btnSuccess.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnSuccess.onHoverState.BorderThickness = 1;
            this.btnSuccess.onHoverState.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(181)))), ((int)(((byte)(255)))));
            this.btnSuccess.onHoverState.ForeColor = System.Drawing.Color.White;
            this.btnSuccess.onHoverState.IconLeftImage = null;
            this.btnSuccess.onHoverState.IconRightImage = null;
            this.btnSuccess.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
            this.btnSuccess.OnIdleState.BorderRadius = 1;
            this.btnSuccess.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnSuccess.OnIdleState.BorderThickness = 1;
            this.btnSuccess.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
            this.btnSuccess.OnIdleState.ForeColor = System.Drawing.Color.White;
            this.btnSuccess.OnIdleState.IconLeftImage = null;
            this.btnSuccess.OnIdleState.IconRightImage = null;
            this.btnSuccess.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(96)))), ((int)(((byte)(144)))));
            this.btnSuccess.OnPressedState.BorderRadius = 1;
            this.btnSuccess.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
            this.btnSuccess.OnPressedState.BorderThickness = 1;
            this.btnSuccess.OnPressedState.FillColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(96)))), ((int)(((byte)(144)))));
            this.btnSuccess.OnPressedState.ForeColor = System.Drawing.Color.White;
            this.btnSuccess.OnPressedState.IconLeftImage = null;
            this.btnSuccess.OnPressedState.IconRightImage = null;
            this.btnSuccess.Size = new System.Drawing.Size(86, 25);
            this.btnSuccess.TabIndex = 5;
            this.btnSuccess.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.btnSuccess.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
            this.btnSuccess.TextMarginLeft = 0;
            this.btnSuccess.TextPadding = new System.Windows.Forms.Padding(0);
            this.btnSuccess.UseDefaultRadiusAndThickness = true;
            this.btnSuccess.Click += new System.EventHandler(this.btnSuccess_Click);
            // 
            // labelResult
            // 
            this.labelResult.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelResult.ForeColor = System.Drawing.Color.DarkRed;
            this.labelResult.Location = new System.Drawing.Point(51, 7);
            this.labelResult.Name = "labelResult";
            this.labelResult.Size = new System.Drawing.Size(252, 69);
            this.labelResult.TabIndex = 1;
            this.labelResult.Text = "Đang xử lý vui lòng đợi! ";
            this.labelResult.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // lbPrice
            // 
            this.lbPrice.AutoSize = true;
            this.lbPrice.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbPrice.ForeColor = System.Drawing.Color.DarkGreen;
            this.lbPrice.Location = new System.Drawing.Point(113, 100);
            this.lbPrice.Name = "lbPrice";
            this.lbPrice.Size = new System.Drawing.Size(56, 16);
            this.lbPrice.TabIndex = 1;
            this.lbPrice.Text = "696969";
            // 
            // MomoConfirm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.ClientSize = new System.Drawing.Size(357, 180);
            this.Controls.Add(this.panelSuccess);
            this.Controls.Add(this.panelComfirm);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "MomoConfirm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "TopUpConfirm";
            this.Load += new System.EventHandler(this.TopUpConfirm_Load);
            this.panelComfirm.ResumeLayout(false);
            this.panelComfirm.PerformLayout();
            this.panelSuccess.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);

		}

		internal static bool erMYmgu9fLG1RfqvaIc()
		{
			return nKWHr4unUZdmcWRRTPC == null;
		}
	}
}
