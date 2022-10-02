package ddt.view
{
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.core.Component;
	import com.pickgliss.utils.ObjectUtils;
	import flash.display.DisplayObject;
	
	public class SimpleItem extends Component
	{
		
		public static const P_backStyle:String = "backStyle";
		
		public static const P_foreStyle:String = "foreStyle";
		
		
		private var _backStyle:String;
		
		private var _foreStyle:String;
		
		private var _back:DisplayObject;
		
		private var _fore:Vector.<DisplayObject>;
		
		private var _foreLinks:Array;
		
		public function SimpleItem()
		{
			super();
		}
		
		override protected function init() : void
		{
			this._fore = new Vector.<DisplayObject>();
			this._foreLinks = new Array();
			super.init();
		}
		
		public function set backStyle(param1:String) : void
		{
			if(param1 == this._backStyle)
			{
				return;
			}
			this._backStyle = param1;
			if(this._back)
			{
				ObjectUtils.disposeObject(this._back);
			}
			this._back = ComponentFactory.Instance.creat(this._backStyle);
			onPropertiesChanged(P_backStyle);
		}
		
		public function set foreStyle(param1:String) : void
		{
			if(param1 == this._foreStyle)
			{
				return;
			}
			this._foreStyle = param1;
			this.clearObject();
			this._foreLinks = ComponentFactory.parasArgs(param1);
			onPropertiesChanged(P_foreStyle);
		}
		
		private function clearObject() : void
		{
			var _loc1_:int = 0;
			while(_loc1_ < this._foreLinks.length)
			{
				if(this._foreLinks[_loc1_])
				{
					ObjectUtils.disposeObject(this._foreLinks[_loc1_]);
				}
				_loc1_++;
			}
		}
		
		private function createObject() : void
		{
			var _loc1_:DisplayObject = null;
			var _loc2_:int = 0;
			while(_loc2_ < this._foreLinks.length)
			{
				_loc1_ = ComponentFactory.Instance.creat(this._foreLinks[_loc2_]);
				this._fore.push(_loc1_);
				_loc2_++;
			}
		}
		
		public function get foreItems() : Vector.<DisplayObject>
		{
			return this._fore;
		}
		
		public function get backItem() : DisplayObject
		{
			return this._back;
		}
		
		override protected function addChildren() : void
		{
			super.addChildren();
			if(this._back)
			{
				addChild(this._back);
			}
			var _loc1_:int = 0;
			while(_loc1_ < this._fore.length)
			{
				addChild(this._fore[_loc1_]);
				_loc1_++;
			}
		}
		
		override protected function onProppertiesUpdate() : void
		{
			super.onProppertiesUpdate();
			if(_changedPropeties[P_backStyle])
			{
				if(this._back && (this._back.width > 0 || this._back.height > 0))
				{
					_width = this._back.width;
					_height = this._back.height;
				}
			}
			if(_changedPropeties[P_foreStyle])
			{
				this.createObject();
			}
		}
		
		override public function dispose() : void
		{
			ObjectUtils.disposeObject(this._back);
			this._back = null;
			var _loc1_:int = 0;
			while(_loc1_ < this._fore.length)
			{
				ObjectUtils.disposeObject(this._fore[_loc1_]);
				this._fore[_loc1_] = null;
				_loc1_++;
			}
			this._foreLinks = null;
			super.dispose();
		}
	}
}