using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Windows.Forms;

namespace Launcher.UserControls.Custom
{
	public class ListPanel : Panel
	{
		public class ItemClickEventArgs : EventArgs
		{
			[CompilerGenerated]
			private ListPanelItem listPanelItem_0;

			private static ItemClickEventArgs PqSn58tIAPESilhdvpF;

			public ListPanelItem Item
			{
				[CompilerGenerated]
				get
				{
					return listPanelItem_0;
				}
				[CompilerGenerated]
				set
				{
					listPanelItem_0 = value;
				}
			}

			internal static bool jIYw3CtGAaeZYKxyc8u()
			{
				return PqSn58tIAPESilhdvpF == null;
			}

			internal static void PK5D21thYFyTSeeTLma()
			{
			}

			internal static void tmOrn3tUJkgUn2D942y()
			{
			}
		}

		public delegate void ItemClickEventHandler(object sender, ItemClickEventArgs e);

		private List<ListPanelItem> list_0 = new List<ListPanelItem>();

		[CompilerGenerated]
		private int int_0;

		[CompilerGenerated]
		private ListPanelItem hXmyEwpyfP;

		[CompilerGenerated]
		private ItemClickEventHandler itemClickEventHandler_0;

		private static ListPanel mMDrmiUwFRHKKC25esd;

		public int SelectedIndex
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

		public ListPanelItem SelectedItem
		{
			[CompilerGenerated]
			get
			{
				return hXmyEwpyfP;
			}
			[CompilerGenerated]
			set
			{
				hXmyEwpyfP = value;
			}
		}

		public event ItemClickEventHandler ItemClick
		{
			[CompilerGenerated]
			add
			{
				ItemClickEventHandler itemClickEventHandler = itemClickEventHandler_0;
				ItemClickEventHandler itemClickEventHandler2;
				do
				{
					itemClickEventHandler2 = itemClickEventHandler;
					ItemClickEventHandler value2 = (ItemClickEventHandler)Delegate.Combine(itemClickEventHandler2, value);
					itemClickEventHandler = Interlocked.CompareExchange(ref itemClickEventHandler_0, value2, itemClickEventHandler2);
				}
				while ((object)itemClickEventHandler != itemClickEventHandler2);
			}
			[CompilerGenerated]
			remove
			{
				ItemClickEventHandler itemClickEventHandler = itemClickEventHandler_0;
				ItemClickEventHandler itemClickEventHandler2;
				do
				{
					itemClickEventHandler2 = itemClickEventHandler;
					ItemClickEventHandler value2 = (ItemClickEventHandler)Delegate.Remove(itemClickEventHandler2, value);
					itemClickEventHandler = Interlocked.CompareExchange(ref itemClickEventHandler_0, value2, itemClickEventHandler2);
				}
				while ((object)itemClickEventHandler != itemClickEventHandler2);
			}
		}

		public ListPanel()
		{
			AutoScroll = true;
			base.BorderStyle = BorderStyle.FixedSingle;
		}

		public void AddItem(ListPanelItem item)
		{
			item.Index = list_0.Count;
			list_0.Add(item);
			base.Controls.Add(item);
			item.BringToFront();
			item.Click += method_0;
		}

		private void method_0(object sender, EventArgs e)
		{
			ListPanelItem listPanelItem = sender as ListPanelItem;
			if (SelectedItem != null)
			{
				SelectedItem.Selected = false;
			}
			SelectedItem = listPanelItem;
			SelectedIndex = listPanelItem.Index;
			listPanelItem.Selected = true;
			itemClickEventHandler_0?.Invoke(this, new ItemClickEventArgs
			{
				Item = listPanelItem
			});
		}

		internal static void GEi025UHqg6urfiExtU()
		{
		}

		internal static void aQajpjUKD06d5WVILg0()
		{
		}

		internal static bool eXGMaXU3CkTxLibHO45()
		{
			return mMDrmiUwFRHKKC25esd == null;
		}

		internal static void WVqBNen2NVH1JJPuNkC()
		{
		}
	}
}
