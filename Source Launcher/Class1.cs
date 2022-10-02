using System.Drawing;
using System.Drawing.Drawing2D;
using System.Runtime.CompilerServices;
using System.Windows.Forms;

internal class Class1 : Panel
{
	[CompilerGenerated]
	private Color color_0;

	[CompilerGenerated]
	private Color color_1;

	[CompilerGenerated]
	private float float_0;

	[SpecialName]
	[CompilerGenerated]
	public void method_0(Color color_2)
	{
		color_0 = color_2;
	}

	[SpecialName]
	[CompilerGenerated]
	public Color method_1()
	{
		return color_0;
	}

	[SpecialName]
	[CompilerGenerated]
	public void method_2(Color color_2)
	{
		color_1 = color_2;
	}

	[SpecialName]
	[CompilerGenerated]
	public Color method_3()
	{
		return color_1;
	}

	[SpecialName]
	[CompilerGenerated]
	public void method_4(float float_1)
	{
		float_0 = float_1;
	}

	[SpecialName]
	[CompilerGenerated]
	public float method_5()
	{
		return float_0;
	}

	protected override void OnPaint(PaintEventArgs e)
	{
		LinearGradientBrush brush = new LinearGradientBrush(base.ClientRectangle, method_1(), method_3(), method_5());
		e.Graphics.FillRectangle(brush, base.ClientRectangle);
		base.OnPaint(e);
	}
}
