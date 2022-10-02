using System;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using Launcher.Properties;
using Launcher.Statics;
using Properties;

namespace Launcher.Test
{
	public class Slider : Form
	{
		private int int_0 = 2;

		private IContainer icontainer_0;

		private Panel panelMain;

		private Panel panel1;

		private Button BtnS5;

		private Button BtnS4;

		private Button btnS3;

		private Button btnS2;

		private Button btnS1;

		private PictureBox picBoxSlide;

		private Timer timer_0;

		internal static Slider FZcrIqnO9P6Lqe7y5m9;

		public Slider()
		{
			InitializeComponent();
		}

		private void btnS1_Click(object sender, EventArgs e)
		{
			string text = $"{Path.GetTempPath()}FixAllow1.png";
			if (!File.Exists(text))
			{
				picBoxSlide.Image = Resources.slide1;
			}
			else
			{
				picBoxSlide.ImageLocation = text;
			}
			btnS1.Focus();
		}

		private void btnS2_Click(object sender, EventArgs e)
		{
			string text = $"{Path.GetTempPath()}FixAllow2.png";
			if (!File.Exists(text))
			{
				picBoxSlide.Image = Resources.slide2;
			}
			else
			{
				picBoxSlide.ImageLocation = text;
			}
			btnS2.Focus();
		}

		private void btnS3_Click(object sender, EventArgs e)
		{
			string text = $"{Path.GetTempPath()}alpha.png";
			if (!File.Exists(text))
			{
				picBoxSlide.Image = Resources.slide3;
			}
			else
			{
				picBoxSlide.ImageLocation = text;
			}
			btnS3.Focus();
		}

		private void BtnS4_Click(object sender, EventArgs e)
		{
			string text = $"{Path.GetTempPath()}slide4.png";
			if (!File.Exists(text))
			{
				picBoxSlide.Image = Resources.slide4;
			}
			else
			{
				picBoxSlide.ImageLocation = text;
			}
			BtnS4.Focus();
		}

		private void BtnS5_Click(object sender, EventArgs e)
		{
			string text = $"{Path.GetTempPath()}slide5.png";
			if (!File.Exists(text))
			{
				picBoxSlide.Image = Resources.slide5;
			}
			else
			{
				picBoxSlide.ImageLocation = text;
			}
			BtnS5.Focus();
		}

		private void timer_0_Tick(object sender, EventArgs e)
		{
			if (int_0 > 5)
			{
				int_0 = 1;
			}
			if (DDTStaticFunc.ButtomStatus == 0)
			{
				switch (int_0)
				{
				case 1:
					btnS1_Click(null, null);
					break;
				case 2:
					btnS2_Click(null, null);
					break;
				case 3:
					btnS3_Click(null, null);
					break;
				case 4:
					BtnS4_Click(null, null);
					break;
				case 5:
					BtnS5_Click(null, null);
					break;
				}
			}
			int_0++;
		}

		private void Slider_Load(object sender, EventArgs e)
		{
			DDTStaticFunc.ButtomStatus = 0;
			picBoxSlide.Size = new Size(Main.Instance.FixScaling(1000), Main.Instance.FixScaling(600));
			int num = Main.Instance.FixScaling(610);
			btnS1.Location = new Point(Main.Instance.FixScaling(440), num);
			btnS2.Location = new Point(Main.Instance.FixScaling(463), num);
			btnS3.Location = new Point(Main.Instance.FixScaling(486), num);
			BtnS4.Location = new Point(Main.Instance.FixScaling(509), num);
			BtnS5.Location = new Point(Main.Instance.FixScaling(532), num);
		}

		private void Slider_Activated(object sender, EventArgs e)
		{
		}

		private void Slider_Deactivate(object sender, EventArgs e)
		{
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
			panelMain = new System.Windows.Forms.Panel();
			panel1 = new System.Windows.Forms.Panel();
			BtnS5 = new System.Windows.Forms.Button();
			BtnS4 = new System.Windows.Forms.Button();
			btnS3 = new System.Windows.Forms.Button();
			btnS2 = new System.Windows.Forms.Button();
			btnS1 = new System.Windows.Forms.Button();
			picBoxSlide = new System.Windows.Forms.PictureBox();
			timer_0 = new System.Windows.Forms.Timer(icontainer_0);
			panel1.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picBoxSlide).BeginInit();
			SuspendLayout();
			panelMain.BackColor = System.Drawing.Color.Black;
			panelMain.Dock = System.Windows.Forms.DockStyle.Fill;
			panelMain.Location = new System.Drawing.Point(0, 0);
			panelMain.Name = "panelMain";
			panelMain.Size = new System.Drawing.Size(1000, 635);
			panelMain.TabIndex = 0;
			panel1.BackColor = System.Drawing.Color.FromArgb(57, 142, 219);
			panel1.Controls.Add(BtnS5);
			panel1.Controls.Add(BtnS4);
			panel1.Controls.Add(btnS3);
			panel1.Controls.Add(btnS2);
			panel1.Controls.Add(btnS1);
			panel1.Controls.Add(picBoxSlide);
			panel1.Dock = System.Windows.Forms.DockStyle.Fill;
			panel1.Location = new System.Drawing.Point(0, 0);
			panel1.Name = "panel1";
			panel1.Size = new System.Drawing.Size(1000, 635);
			panel1.TabIndex = 3;
			BtnS5.BackColor = System.Drawing.Color.FromArgb(32, 47, 66);
			BtnS5.Cursor = System.Windows.Forms.Cursors.Hand;
			BtnS5.FlatAppearance.BorderSize = 0;
			BtnS5.Location = new System.Drawing.Point(532, 610);
			BtnS5.Name = "BtnS5";
			BtnS5.Size = new System.Drawing.Size(15, 15);
			BtnS5.TabIndex = 1;
			BtnS5.UseVisualStyleBackColor = false;
			BtnS5.Click += new System.EventHandler(BtnS5_Click);
			BtnS4.BackColor = System.Drawing.Color.FromArgb(32, 47, 66);
			BtnS4.Cursor = System.Windows.Forms.Cursors.Hand;
			BtnS4.FlatAppearance.BorderSize = 0;
			BtnS4.Location = new System.Drawing.Point(509, 610);
			BtnS4.Name = "BtnS4";
			BtnS4.Size = new System.Drawing.Size(15, 15);
			BtnS4.TabIndex = 1;
			BtnS4.UseVisualStyleBackColor = false;
			BtnS4.Click += new System.EventHandler(BtnS4_Click);
			btnS3.BackColor = System.Drawing.Color.FromArgb(32, 47, 66);
			btnS3.Cursor = System.Windows.Forms.Cursors.Hand;
			btnS3.FlatAppearance.BorderSize = 0;
			btnS3.Location = new System.Drawing.Point(486, 610);
			btnS3.Name = "btnS3";
			btnS3.Size = new System.Drawing.Size(15, 15);
			btnS3.TabIndex = 1;
			btnS3.UseVisualStyleBackColor = false;
			btnS3.Click += new System.EventHandler(btnS3_Click);
			btnS2.BackColor = System.Drawing.Color.FromArgb(32, 47, 66);
			btnS2.Cursor = System.Windows.Forms.Cursors.Hand;
			btnS2.FlatAppearance.BorderSize = 0;
			btnS2.Location = new System.Drawing.Point(463, 610);
			btnS2.Name = "btnS2";
			btnS2.Size = new System.Drawing.Size(15, 15);
			btnS2.TabIndex = 1;
			btnS2.UseVisualStyleBackColor = false;
			btnS2.Click += new System.EventHandler(btnS2_Click);
			btnS1.BackColor = System.Drawing.Color.FromArgb(32, 47, 66);
			btnS1.Cursor = System.Windows.Forms.Cursors.Hand;
			btnS1.FlatAppearance.BorderSize = 0;
			btnS1.Location = new System.Drawing.Point(440, 610);
			btnS1.Name = "btnS1";
			btnS1.Size = new System.Drawing.Size(15, 15);
			btnS1.TabIndex = 1;
			btnS1.UseVisualStyleBackColor = false;
			btnS1.Click += new System.EventHandler(btnS1_Click);
			picBoxSlide.Dock = System.Windows.Forms.DockStyle.Top;
			picBoxSlide.Image = Resources.slide1;
			picBoxSlide.Location = new System.Drawing.Point(0, 0);
			picBoxSlide.Name = "picBoxSlide";
			picBoxSlide.Size = new System.Drawing.Size(1000, 600);
			picBoxSlide.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picBoxSlide.TabIndex = 0;
			picBoxSlide.TabStop = false;
			timer_0.Enabled = true;
			timer_0.Interval = 3000;
			timer_0.Tick += new System.EventHandler(timer_0_Tick);
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			base.ClientSize = new System.Drawing.Size(1000, 635);
			base.Controls.Add(panel1);
			base.Controls.Add(panelMain);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Name = "Slider";
			base.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
			Text = "TestSlider";
			base.Activated += new System.EventHandler(Slider_Activated);
			base.Deactivate += new System.EventHandler(Slider_Deactivate);
			base.Load += new System.EventHandler(Slider_Load);
			panel1.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)picBoxSlide).EndInit();
			ResumeLayout(false);
		}

		internal static void FRMtkGncIRxe7trgY8c()
		{
		}

		internal static bool UGaBAanRtvVTUFLpZif()
		{
			return FZcrIqnO9P6Lqe7y5m9 == null;
		}

		internal static void VHupEb941qnoG70Jmtd()
		{
		}
	}
}
