using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Runtime.CompilerServices;
using System.Windows.Forms;

namespace Launcher.UserControls.Custom
{
	public class ListPanelItem : Panel
	{
		private bool bool_0;

		[CompilerGenerated]
		private Size size_0;

		[CompilerGenerated]
		private Image image_0;

		[CompilerGenerated]
		private string string_0;

		[CompilerGenerated]
		private string string_1;

		[CompilerGenerated]
		private Color color_0;

		[CompilerGenerated]
		private Color color_1;

		[CompilerGenerated]
		private Font font_0;

		[CompilerGenerated]
		private Font font_1;

		[CompilerGenerated]
		private int int_0;

		[CompilerGenerated]
		private Color color_2;

		[CompilerGenerated]
		private Color color_3;

		private bool bool_1;

		private static ListPanelItem xdDSwanmV7xopnWJc9B;

		public Size ImageSize
		{
			[CompilerGenerated]
			get
			{
				return size_0;
			}
			[CompilerGenerated]
			set
			{
				size_0 = value;
			}
		}

		public Image Image
		{
			[CompilerGenerated]
			get
			{
				return image_0;
			}
			[CompilerGenerated]
			set
			{
				image_0 = value;
			}
		}

		public string Caption
		{
			[CompilerGenerated]
			get
			{
				return string_0;
			}
			[CompilerGenerated]
			set
			{
				string_0 = value;
			}
		}

		public string Content
		{
			[CompilerGenerated]
			get
			{
				return string_1;
			}
			[CompilerGenerated]
			set
			{
				string_1 = value;
			}
		}

		public Color CaptionColor
		{
			[CompilerGenerated]
			get
			{
				return color_0;
			}
			[CompilerGenerated]
			set
			{
				color_0 = value;
			}
		}

		public Color ContentColor
		{
			[CompilerGenerated]
			get
			{
				return color_1;
			}
			[CompilerGenerated]
			set
			{
				color_1 = value;
			}
		}

		public Font CaptionFont
		{
			[CompilerGenerated]
			get
			{
				return font_0;
			}
			[CompilerGenerated]
			set
			{
				font_0 = value;
			}
		}

		public Font ContentFont
		{
			[CompilerGenerated]
			get
			{
				return font_1;
			}
			[CompilerGenerated]
			set
			{
				font_1 = value;
			}
		}

		public int Index
		{
			[CompilerGenerated]
			get
			{
				return int_0;
			}
			[CompilerGenerated]
			set
			{
				int_0 = value;
			}
		}

		public bool Selected
		{
			get
			{
				return bool_0;
			}
			set
			{
				bool_0 = value;
				Invalidate();
			}
		}

		public Color SelectedColor
		{
			[CompilerGenerated]
			get
			{
				return color_2;
			}
			[CompilerGenerated]
			set
			{
				color_2 = value;
			}
		}

		public Color HoverColor
		{
			[CompilerGenerated]
			get
			{
				return color_3;
			}
			[CompilerGenerated]
			set
			{
				color_3 = value;
			}
		}

		public ListPanelItem()
		{
			DoubleBuffered = true;
			ImageSize = new Size(100, 100);
			CaptionColor = Color.Blue;
			ContentColor = Color.Green;
			CaptionFont = new Font(Font.FontFamily, 13f, FontStyle.Bold | FontStyle.Underline);
			ContentFont = new Font(Font.FontFamily, 10f, FontStyle.Regular);
			Dock = DockStyle.Top;
			SelectedColor = Color.Orange;
			HoverColor = Color.Yellow;
			Caption = "";
			Content = "";
		}

		protected override void OnPaint(PaintEventArgs e)
		{
			Color color = (bool_1 ? Color.FromArgb(0, HoverColor) : Color.FromArgb(0, SelectedColor));
			Color color2 = (bool_1 ? HoverColor : SelectedColor);
			Rectangle rect = new Rectangle(base.ClientRectangle.Left, base.ClientRectangle.Top, base.ClientRectangle.Width, base.ClientRectangle.Height - 2);
			using (LinearGradientBrush brush = new LinearGradientBrush(base.ClientRectangle, color, color2, 90f))
			{
				if (!bool_1)
				{
					if (Selected)
					{
						e.Graphics.FillRectangle(brush, rect);
					}
				}
				else
				{
					e.Graphics.FillRectangle(brush, rect);
				}
			}
			if (Image != null)
			{
				e.Graphics.DrawImage(Image, new Rectangle(new Point(5, 5), ImageSize));
			}
			StringFormat format = new StringFormat
			{
				LineAlignment = StringAlignment.Center
			};
			e.Graphics.DrawString(Caption, CaptionFont, new SolidBrush(CaptionColor), new RectangleF(ImageSize.Width + 10, 5f, base.Width - ImageSize.Width - 10, CaptionFont.SizeInPoints * 1.5f), format);
			int num = base.Width - ImageSize.Width - 10;
			SizeF sizeF = e.Graphics.MeasureString(Content, ContentFont);
			float num2 = sizeF.Width / (float)num * sizeF.Height + sizeF.Height;
			int num3 = (int)((double)CaptionFont.SizeInPoints * 1.5) + (int)num2 + 1;
			if (base.Height != num3)
			{
				base.Height = ((num3 > ImageSize.Height + 10) ? num3 : (ImageSize.Height + 10));
			}
			e.Graphics.DrawString(Content, ContentFont, new SolidBrush(ContentColor), new RectangleF(ImageSize.Width + 10, CaptionFont.SizeInPoints * 1.5f + 5f, base.Width - ImageSize.Width - 10, num2));
			e.Graphics.DrawLine(Pens.Silver, new Point(base.ClientRectangle.Left, base.ClientRectangle.Bottom - 1), new Point(base.ClientRectangle.Right, base.ClientRectangle.Bottom - 1));
			base.OnPaint(e);
		}

		protected override void OnMouseEnter(EventArgs e)
		{
			bool_1 = true;
			base.OnMouseEnter(e);
			Invalidate();
		}

		protected override void OnMouseLeave(EventArgs e)
		{
			bool_1 = false;
			base.OnMouseLeave(e);
			Invalidate();
		}

		internal static void UcAJhnn0iYTUmeR6IJt()
		{
		}

		internal static void xAemeanrCQiBFIUdvah()
		{
		}

		internal static bool aLUWLcnpxjE9lEMHYi9()
		{
			return xdDSwanmV7xopnWJc9B == null;
		}

		internal static void xBAZ0KnZAY8c9qQ0tkf()
		{
		}
	}
}
