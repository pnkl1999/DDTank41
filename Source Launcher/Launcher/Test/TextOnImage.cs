using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Windows.Forms;
using Launcher.Properties;
using Properties;

namespace Launcher.Test
{
	public class TextOnImage : Form
	{
		private IContainer icontainer_0;

		private Panel panel1;

		private Button button1;

		private Panel panel2;

		private Label label1;

		internal static TextOnImage X9vSwQ9ugfgKxxOP1Fa;

		public TextOnImage()
		{
			InitializeComponent();
		}

		private Image method_0(string string_0, Image image_0, Color color_0)
		{
			Bitmap bitmap = new Bitmap(image_0);
			using Graphics graphics = Graphics.FromImage(bitmap);
			graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
			graphics.SmoothingMode = SmoothingMode.HighQuality;
			graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;
			graphics.CompositingQuality = CompositingQuality.HighQuality;
			using (SolidBrush brush = new SolidBrush(color_0))
			{
				using Font font = new Font("Microsoft Sans Serif", 16f, FontStyle.Bold, GraphicsUnit.Pixel);
				graphics.DrawString(string_0, font, brush, 50f, 13f);
			}
			graphics.Save();
			return bitmap;
		}

		private void button1_Click(object sender, EventArgs e)
		{
			method_0("Gunny 4.1 S3", Resources.serverBg2, Color.White);
			panel1.BackgroundImage = method_0("Gunny 4.1 S3", Resources.serverBg2, Color.White);
			method_0("Gunny 4.1 S3", Resources.serverBg2, Color.Black);
			panel2.BackgroundImage = method_0("Gunny 4.1 S3", Resources.serverBg2, Color.Black);
		}

		private void TextOnImage_Load(object sender, EventArgs e)
		{
			string text = "Adjust uilabel width depending on the text swift\r\nDynamically adjust width of UILabel in Swift 3, Try using : myLabel.sizeToFit(). on your label.This should update the label's frame to fit the content. In my project, there is a UILabel with text. The font size is 16pt. The text contents are changed depending on different cases. I hope it can automatically adjust the width of UILabel to fit the total width of texts without stretching.\r\nresizing UILabels based on total width of text, If Want to Make size of UILabel Based on TextSize and TextLength then use intrinsicContentSize. Below is sample code for that: Make UILabel Fit Text. To make UILabel adjust its width to fit the text, I will use auto-layout constraints. I will select UILabel on the view and will add two new constraints: Top and Leading constraints. Now with the two new constraints added, I can open Swift code editor and set a longer text to UILabel.";
			label1.Text = text;
		}

		private string method_1(string string_0, Font font_0, int int_0)
		{
			char char_0 = '\u200a';
			List<string> list_0 = string_0.Split(' ').ToList();
			if (list_0.Capacity < 2)
			{
				return string_0;
			}
			int num = list_0.Capacity - 1;
			int num2 = TextRenderer.MeasureText(string_0.Replace(" ", ""), font_0).Width;
			int int_2 = TextRenderer.MeasureText(list_0[0] + char_0, font_0).Width - TextRenderer.MeasureText(list_0[0], font_0).Width;
			int int_ = (int_0 - num2) / num / int_2;
			float float_0 = int_0 - (num2 + int_ * num * int_2);
			return ((Func<string>)delegate
			{
				string text = "";
				string text2 = "";
				for (int i = 0; i < int_; i++)
				{
					text += char_0;
				}
				foreach (string item in list_0)
				{
					text2 = text2 + item + text;
					if (float_0 > 0f)
					{
						text2 += char_0;
						float_0 -= int_2;
					}
				}
				return text2.TrimEnd();
			})();
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
			panel1 = new System.Windows.Forms.Panel();
			button1 = new System.Windows.Forms.Button();
			panel2 = new System.Windows.Forms.Panel();
			label1 = new System.Windows.Forms.Label();
			SuspendLayout();
			panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
			panel1.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
			panel1.Location = new System.Drawing.Point(137, 12);
			panel1.Name = "panel1";
			panel1.Size = new System.Drawing.Size(200, 60);
			panel1.TabIndex = 0;
			button1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			button1.Location = new System.Drawing.Point(33, 12);
			button1.Name = "button1";
			button1.Size = new System.Drawing.Size(75, 60);
			button1.TabIndex = 1;
			button1.Text = "button1";
			button1.UseVisualStyleBackColor = true;
			button1.Click += new System.EventHandler(button1_Click);
			panel2.BackColor = System.Drawing.SystemColors.ActiveCaption;
			panel2.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
			panel2.Location = new System.Drawing.Point(368, 12);
			panel2.Name = "panel2";
			panel2.Size = new System.Drawing.Size(200, 60);
			panel2.TabIndex = 0;
			label1.AutoSize = true;
			label1.Font = new System.Drawing.Font("Microsoft Tai Le", 9f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label1.Location = new System.Drawing.Point(30, 100);
			label1.MaximumSize = new System.Drawing.Size(300, 450);
			label1.MinimumSize = new System.Drawing.Size(150, 25);
			label1.Name = "label1";
			label1.Padding = new System.Windows.Forms.Padding(5);
			label1.Size = new System.Drawing.Size(150, 26);
			label1.TabIndex = 2;
			label1.Text = "label1";
			base.AutoScaleDimensions = new System.Drawing.SizeF(96f, 96f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
			base.ClientSize = new System.Drawing.Size(800, 450);
			base.Controls.Add(label1);
			base.Controls.Add(button1);
			base.Controls.Add(panel2);
			base.Controls.Add(panel1);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			base.Name = "TextOnImage";
			base.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			Text = "TextOnImage";
			base.Load += new System.EventHandler(TextOnImage_Load);
			ResumeLayout(false);
			PerformLayout();
		}

		internal static void IiIff09WNPmNiTAOD0H()
		{
		}

		internal static void Hl5QPe9XB1oM0dcdDNb()
		{
		}

		internal static bool vbFF7G9NLbTvblCYAJp()
		{
			return X9vSwQ9ugfgKxxOP1Fa == null;
		}
	}
}
