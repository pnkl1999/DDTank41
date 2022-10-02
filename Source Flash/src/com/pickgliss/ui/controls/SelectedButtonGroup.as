package com.pickgliss.ui.controls
{
	import com.pickgliss.ui.core.Disposeable;
	import com.pickgliss.utils.ObjectUtils;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class SelectedButtonGroup extends EventDispatcher implements Disposeable
	{
		
		
		private var _canUnSelect:Boolean;
		
		private var _currentSelecetdIndex:int;
		
		private var _items:Vector.<ISelectable>;
		
		private var _lastSelectedButton:ISelectable;
		
		private var _mutiSelectCount:int;
		
		public function SelectedButtonGroup(param1:Boolean = false, param2:int = 1)
		{
			super();
			this._mutiSelectCount = param2;
			this._canUnSelect = param1;
			this._items = new Vector.<ISelectable>();
		}
		
		public function length() : int
		{
			return this._items.length;
		}
		
		public function getItemByIndex(param1:int) : ISelectable
		{
			return this._items[param1];
		}
		
		public function addSelectItem(param1:ISelectable) : void
		{
			param1.addEventListener(MouseEvent.CLICK,this.__onItemClicked);
			param1.autoSelect = false;
			this._items.push(param1);
		}
		
		public function dispose() : void
		{
			var _loc1_:int = 0;
			while(_loc1_ < this._items.length)
			{
				this.removeItemByIndex(0);
			}
			this._lastSelectedButton = null;
			this._items = null;
		}
		
		public function getSelectIndexByItem(param1:ISelectable) : int
		{
			return this._items.indexOf(param1);
		}
		
		public function removeItemByIndex(param1:int) : void
		{
			if(param1 != -1)
			{
				this._items[param1].removeEventListener(MouseEvent.CLICK,this.__onItemClicked);
				ObjectUtils.disposeObject(this._items[param1]);
				this._items.splice(param1,1);
			}
		}
		
		public function removeSelectItem(param1:ISelectable) : void
		{
			var _loc2_:int = this._items.indexOf(param1);
			this.removeItemByIndex(_loc2_);
		}
		
		public function get selectIndex() : int
		{
			return this._items.indexOf(this._lastSelectedButton);
		}
		
		public function set selectIndex(param1:int) : void
		{
			var _loc2_:ISelectable = null;
			if(param1 == -1)
			{
				this._currentSelecetdIndex = param1;
				for each(_loc2_ in this._items)
				{
					_loc2_.selected = false;
				}
				return;
			}
			var _loc3_:Boolean = this._currentSelecetdIndex != param1;
			var _loc4_:ISelectable = this._items[param1];
			if(!_loc4_.selected)
			{
				if(this._lastSelectedButton && this.selectedCount == this._mutiSelectCount)
				{
					this._lastSelectedButton.selected = false;
				}
				_loc4_.selected = true;
				this._currentSelecetdIndex = param1;
				this._lastSelectedButton = _loc4_;
			}
			else if(this._canUnSelect)
			{
				_loc4_.selected = false;
			}
			if(_loc3_)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get selectedCount() : int
		{
			var _loc1_:int = 0;
			var _loc2_:int = 0;
			while(_loc2_ < this._items.length)
			{
				if(this._items[_loc2_].selected)
				{
					_loc1_++;
				}
				_loc2_++;
			}
			return _loc1_;
		}
		
		public function set selectedCount(param1:int) : void
		{
			this._mutiSelectCount = param1;
		}
		
		private function __onItemClicked(param1:MouseEvent) : void
		{
			var _loc2_:ISelectable = param1.currentTarget as ISelectable;
			this.selectIndex = this._items.indexOf(_loc2_);
		}
	}
}