using System;
using System.Drawing;
using System.Runtime.CompilerServices;
using System.Windows.Forms;
using Launcher.Properties;
using Properties;

internal class Class2 : PictureBox
{
	[CompilerGenerated]
	private string string_0;

	[CompilerGenerated]
	private int int_0;

	[CompilerGenerated]
	private SolidBrush solidBrush_0;

	[SpecialName]
	[CompilerGenerated]
	public string method_0()
	{
		return string_0;
	}

	[SpecialName]
	[CompilerGenerated]
	public void method_1(string string_1)
	{
		string_0 = string_1;
	}

	[SpecialName]
	[CompilerGenerated]
	public int method_2()
	{
		return int_0;
	}

	[SpecialName]
	[CompilerGenerated]
	public void method_3(int int_1)
	{
		int_0 = int_1;
	}

	[SpecialName]
	[CompilerGenerated]
	public SolidBrush method_4()
	{
		return solidBrush_0;
	}

	[SpecialName]
	[CompilerGenerated]
	public void method_5(SolidBrush solidBrush_1)
	{
		solidBrush_0 = solidBrush_1;
	}

	public Class2()
	{
		base.Cursor = Cursors.Hand;
		base.SizeMode = PictureBoxSizeMode.Zoom;
		base.Size = new Size(230, 60);
		base.Image = Resources.label_up;
		method_5(new SolidBrush(Color.White));
		method_1("Xác nhận");
		method_3(12);
	}

	protected override void OnMouseHover(EventArgs e)
	{
		base.OnMouseHover(e);
		base.Image = Resources.label_down;
		method_5(new SolidBrush(Color.Gold));
		Invalidate();
	}

	protected override void OnMouseLeave(EventArgs e)
	{
		base.OnMouseLeave(e);
		base.Image = Resources.label_up;
		method_5(new SolidBrush(Color.White));
		Invalidate();
	}

	protected override void OnPaint(PaintEventArgs e)
	{
		base.OnPaint(e);
		StringFormat format = new StringFormat
		{
			Alignment = StringAlignment.Center,
			LineAlignment = StringAlignment.Center
		};
		using Font font = new Font("Arial", method_2(), FontStyle.Bold, GraphicsUnit.Pixel);
		e.Graphics.DrawString(method_0(), font, method_4(), new Rectangle(0, 0, base.Width, base.Height), format);
	}
}
