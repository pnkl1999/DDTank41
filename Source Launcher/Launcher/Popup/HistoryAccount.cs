using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Bunifu.UI.WinForms;
using Launcher.Forms;
using Launcher.Properties;
using Properties;

namespace Launcher.Popup
{
	public class HistoryAccount : Form
	{
		public enum DeviceCap
		{
			VERTRES = 10,
			DESKTOPVERTRES = 117,
			LOGPIXELSY = 90
		}

		protected new Login Owner;

		private List<string> list_0;

		private Point point_0;

		private int int_0;

		private int int_1;

		private decimal decimal_0 = 1m;

		private IContainer icontainer_0;

		private Panel pnTop;

		private Label label1;

		private Panel pnButtom;

		private Panel pnContent;

		private BunifuVScrollBar bunifuVScrollBar;

		private PictureBox picClose;

		private Class2 zUjXaYrmCR;

		private static HistoryAccount TCsURfAsBA1yXi9cefr;

		public HistoryAccount(Login owner, List<string> acc)
		{
			InitializeComponent();
			method_0();
			Owner = owner;
			list_0 = acc;
			point_0 = owner.Location;
			int_0 = owner.Width;
			int_1 = owner.Height;
		}

		private void method_0()
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

		[DllImport("gdi32.dll")]
		private static extern int GetDeviceCaps(IntPtr intptr_0, int int_2);

		private void picClose_Click(object sender, EventArgs e)
		{
			Close();
		}

		private void HistoryAccount_Load(object sender, EventArgs e)
		{
			base.Height = int_1;
			base.Location = new Point(point_0.X + int_0 / 2, point_0.Y);
			int num = 5;
			int num2 = 5;
			for (int i = 0; i < list_0.Count; i++)
			{
				Class2 @class = new Class2();
				@class.method_3((int)(12m * decimal_0));
				@class.Width = zUjXaYrmCR.Width;
				@class.Height = zUjXaYrmCR.Height;
				@class.SizeMode = PictureBoxSizeMode.StretchImage;
				@class.Location = new Point(num, num2);
				@class.method_1(list_0[i]);
				@class.Name = list_0[i];
				Class2 class2 = @class;
				class2.Click += zUjXaYrmCR_Click;
				pnContent.Controls.Add(class2);
				num2 += zUjXaYrmCR.Height - 2;
			}
			pnContent.Controls.Remove(zUjXaYrmCR);
		}

		private void zUjXaYrmCR_Click(object sender, EventArgs e)
		{
			if (sender is Class2)
			{
				Owner.LoginSaveAccount((sender as Class2).Name);
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Launcher.Popup.HistoryAccount));
			pnTop = new System.Windows.Forms.Panel();
			picClose = new System.Windows.Forms.PictureBox();
			label1 = new System.Windows.Forms.Label();
			pnButtom = new System.Windows.Forms.Panel();
			pnContent = new System.Windows.Forms.Panel();
			bunifuVScrollBar = new Bunifu.UI.WinForms.BunifuVScrollBar();
			zUjXaYrmCR = new Class2();
			pnTop.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picClose).BeginInit();
			pnContent.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)zUjXaYrmCR).BeginInit();
			SuspendLayout();
			pnTop.BackColor = System.Drawing.Color.FromArgb(49, 60, 74);
			pnTop.Controls.Add(picClose);
			pnTop.Controls.Add(label1);
			pnTop.Dock = System.Windows.Forms.DockStyle.Top;
			pnTop.Location = new System.Drawing.Point(0, 0);
			pnTop.Name = "pnTop";
			pnTop.Size = new System.Drawing.Size(250, 40);
			pnTop.TabIndex = 0;
			picClose.Cursor = System.Windows.Forms.Cursors.Hand;
			picClose.ErrorImage = null;
			picClose.Image = Resources.icons8_close_window_40;
			picClose.Location = new System.Drawing.Point(223, 11);
			picClose.Name = "picClose";
			picClose.Size = new System.Drawing.Size(20, 20);
			picClose.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			picClose.TabIndex = 1;
			picClose.TabStop = false;
			picClose.Click += new System.EventHandler(picClose_Click);
			label1.AutoSize = true;
			label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			label1.ForeColor = System.Drawing.Color.White;
			label1.Location = new System.Drawing.Point(5, 12);
			label1.Name = "label1";
			label1.Size = new System.Drawing.Size(157, 16);
			label1.TabIndex = 0;
			label1.Text = "Tài khoản đã sử dụng";
			pnButtom.BackColor = System.Drawing.Color.FromArgb(24, 106, 192);
			pnButtom.Dock = System.Windows.Forms.DockStyle.Bottom;
			pnButtom.Location = new System.Drawing.Point(0, 325);
			pnButtom.Name = "pnButtom";
			pnButtom.Size = new System.Drawing.Size(250, 4);
			pnButtom.TabIndex = 1;
			pnContent.BackColor = System.Drawing.Color.FromArgb(83, 51, 34);
			pnContent.Controls.Add(zUjXaYrmCR);
			pnContent.Dock = System.Windows.Forms.DockStyle.Fill;
			pnContent.Location = new System.Drawing.Point(0, 40);
			pnContent.Name = "pnContent";
			pnContent.Size = new System.Drawing.Size(250, 285);
			pnContent.TabIndex = 2;
			bunifuVScrollBar.AllowCursorChanges = true;
			bunifuVScrollBar.AllowHomeEndKeysDetection = false;
			bunifuVScrollBar.AllowIncrementalClickMoves = true;
			bunifuVScrollBar.AllowMouseDownEffects = true;
			bunifuVScrollBar.AllowMouseHoverEffects = true;
			bunifuVScrollBar.AllowScrollingAnimations = true;
			bunifuVScrollBar.AllowScrollKeysDetection = true;
			bunifuVScrollBar.AllowScrollOptionsMenu = true;
			bunifuVScrollBar.AllowShrinkingOnFocusLost = false;
			bunifuVScrollBar.BackgroundColor = System.Drawing.Color.FromArgb(65, 85, 105);
			bunifuVScrollBar.BackgroundImage = (System.Drawing.Image)resources.GetObject("bunifuVScrollBar.BackgroundImage");
			bunifuVScrollBar.BindingContainer = pnContent;
			bunifuVScrollBar.BorderColor = System.Drawing.Color.FromArgb(65, 85, 105);
			bunifuVScrollBar.BorderRadius = 14;
			bunifuVScrollBar.BorderThickness = 1;
			bunifuVScrollBar.Dock = System.Windows.Forms.DockStyle.Right;
			bunifuVScrollBar.DurationBeforeShrink = 2000;
			bunifuVScrollBar.LargeChange = 10;
			bunifuVScrollBar.Location = new System.Drawing.Point(240, 40);
			bunifuVScrollBar.Maximum = 100;
			bunifuVScrollBar.Minimum = 0;
			bunifuVScrollBar.MinimumThumbLength = 18;
			bunifuVScrollBar.Name = "bunifuVScrollBar";
			bunifuVScrollBar.OnDisable.ScrollBarBorderColor = System.Drawing.Color.Silver;
			bunifuVScrollBar.OnDisable.ScrollBarColor = System.Drawing.Color.Transparent;
			bunifuVScrollBar.OnDisable.ThumbColor = System.Drawing.Color.Silver;
			bunifuVScrollBar.ScrollBarBorderColor = System.Drawing.Color.FromArgb(65, 85, 105);
			bunifuVScrollBar.ScrollBarColor = System.Drawing.Color.FromArgb(65, 85, 105);
			bunifuVScrollBar.ShrinkSizeLimit = 3;
			bunifuVScrollBar.Size = new System.Drawing.Size(10, 285);
			bunifuVScrollBar.SmallChange = 1;
			bunifuVScrollBar.TabIndex = 0;
			bunifuVScrollBar.ThumbColor = System.Drawing.Color.White;
			bunifuVScrollBar.ThumbLength = 28;
			bunifuVScrollBar.ThumbMargin = 1;
			bunifuVScrollBar.ThumbStyle = Bunifu.UI.WinForms.BunifuVScrollBar.ThumbStyles.Inset;
			bunifuVScrollBar.Value = 0;
			zUjXaYrmCR.method_1("Xác nhận");
			zUjXaYrmCR.Cursor = System.Windows.Forms.Cursors.Hand;
			zUjXaYrmCR.Image = (System.Drawing.Image)resources.GetObject("labelImage1.Image");
			zUjXaYrmCR.Location = new System.Drawing.Point(5, 5);
			zUjXaYrmCR.Name = "labelImage1";
			zUjXaYrmCR.Size = new System.Drawing.Size(230, 40);
			zUjXaYrmCR.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			zUjXaYrmCR.TabIndex = 0;
			zUjXaYrmCR.TabStop = false;
			zUjXaYrmCR.method_3(12);
			zUjXaYrmCR.Click += new System.EventHandler(zUjXaYrmCR_Click);
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			BackColor = System.Drawing.Color.FromArgb(83, 51, 34);
			base.ClientSize = new System.Drawing.Size(250, 329);
			base.Controls.Add(bunifuVScrollBar);
			base.Controls.Add(pnContent);
			base.Controls.Add(pnButtom);
			base.Controls.Add(pnTop);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Name = "HistoryAccount";
			base.Opacity = 0.9;
			base.ShowIcon = false;
			base.ShowInTaskbar = false;
			base.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			Text = "HistoryAccount";
			base.Load += new System.EventHandler(HistoryAccount_Load);
			pnTop.ResumeLayout(false);
			pnTop.PerformLayout();
			((System.ComponentModel.ISupportInitialize)picClose).EndInit();
			pnContent.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)zUjXaYrmCR).EndInit();
			ResumeLayout(false);
		}

		internal static bool VJEpp6AVcxTPargHBhk()
		{
			return TCsURfAsBA1yXi9cefr == null;
		}

		internal static void JBvEiH4jrMAoZCQJ3j4()
		{
		}
	}
}
