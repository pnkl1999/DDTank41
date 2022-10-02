using System;
using System.Drawing;
using System.Windows.Forms;

namespace Launcher.UserControls.Custom
{
	public class GrowLabel : Label
	{
		private bool bool_0;

		internal static GrowLabel mygW9tUhtQTZYcbvmNS;

		public GrowLabel()
		{
			AutoSize = false;
		}

		private void method_0()
		{
			if (!bool_0)
			{
				try
				{
					bool_0 = true;
					base.Height = TextRenderer.MeasureText(proposedSize: new Size(base.Width, int.MaxValue), text: Text, font: Font, flags: TextFormatFlags.WordBreak).Height;
				}
				finally
				{
					bool_0 = false;
				}
			}
		}

		protected override void OnTextChanged(EventArgs e)
		{
			base.OnTextChanged(e);
			method_0();
		}

		protected override void OnFontChanged(EventArgs e)
		{
			base.OnFontChanged(e);
			method_0();
		}

		protected override void OnSizeChanged(EventArgs e)
		{
			base.OnSizeChanged(e);
			method_0();
		}

		internal static void N99MEbU9tQA5CEdeFed()
		{
		}

		internal static void VgwxuYUkViXjjTMlixG()
		{
		}

		internal static bool ElJEnsUUMlP4XuopDsg()
		{
			return mygW9tUhtQTZYcbvmNS == null;
		}

		internal static void OHt2s4UyfeSNfl4MRKP()
		{
		}
	}
}
