package bagAndInfo.bag
{
	import bagAndInfo.cell.BagCell;
	import baglocked.BaglockedManager;
	import com.pickgliss.events.FrameEvent;
	import com.pickgliss.ui.AlertManager;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.controls.alert.BaseAlerFrame;
	import com.pickgliss.ui.image.MutipleImage;
	import com.pickgliss.ui.image.Scale9CornerImage;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.data.BagInfo;
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.SelfInfo;
	import ddt.events.CellEvent;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.SoundManager;
	import ddt.utils.PositionUtils;
	import equipretrieve.RetrieveController;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class BankBagView extends BagView
	{
		
		private static var LIST_WIDTH:int = 330;
		
		private static var LIST_HEIGHT:int = 320;
		
		
		private var _bank:BankBagListView;
		
		private var BG:Scale9CornerImage;
		
		private var title:Bitmap;
		
		private var smallBg:MutipleImage;
		
		private var numBg:Bitmap;
		
		public function BankBagView()
		{
			super();
		}
		
		override protected function init() : void
		{
			super.init();
			this.setData(PlayerManager.Instance.Self);
			PositionUtils.setPos(_equipBtn,"consortion.bank.equipPos");
			PositionUtils.setPos(_propBtn,"consortion.bank.propPos");
			PositionUtils.setPos(_cardBtn,"consortion.bank.cardPos");
		}
		
		override protected function set_breakBtn_enable() : void
		{
			if(_keySetBtn && _isSkillCanUse())
			{
				_keySetBtn.enable = true;
			}
			if(_sortBagBtn)
			{
				_sortBagBtn.enable = true;
			}
		}
		
		override protected function set_text_location() : void
		{
			if(_goldText)
			{
				_goldText.y += 31;
			}
			if(_moneyText)
			{
				_moneyText.y += 31;
			}
			if(_giftText)
			{
				_giftText.y += 31;
			}
			if(_medalField)
			{
				_medalField.y += 31;
			}
		}
		
		override protected function set_btn_location() : void
		{
			_goldButton.y += 32;
			_giftButton.y += 32;
			_moneyButton.y += 32;
			_medalButton.y += 32;
			_sellBtn.y += 32;
			_continueBtn.y += 32;
			_breakBtn.y += 32;
			_keySetBtn.y += 32;
		}
		
		override protected function initEvent() : void
		{
			super.initEvent();
			this._bank.addEventListener("itemclick",this.__bankCellClick);
			this._bank.addEventListener("doubleclick",this.__bankCellDoubleClick);
			_proplist.addEventListener("doubleclick",this.__cellDoubleClick);
			_equiplist.addEventListener("change",this.__listChange);
			_proplist.addEventListener("change",this.__listChange);
		}
		
		override protected function removeEvents() : void
		{
			super.removeEvents();
			this._bank.removeEventListener("itemclick",this.__bankCellClick);
			this._bank.removeEventListener("doubleclick",this.__bankCellDoubleClick);
			_proplist.removeEventListener("doubleclick",this.__cellDoubleClick);
			_equiplist.removeEventListener("change",this.__listChange);
			_proplist.removeEventListener("change",this.__listChange);
		}
		
		override protected function initBackGround() : void
		{
			this.BG = ComponentFactory.Instance.creatComponentByStylename("consortion.bankBag.bg");
			this._bank = new BankBagListView(51);
			PositionUtils.setPos(this._bank,"consortion.bank.Pos");
			this.title = ComponentFactory.Instance.creatBitmap("asset.consortion.bank.title");
			this.smallBg = ComponentFactory.Instance.creatComponentByStylename("consortion.bankBag.mutiple");
			_bgShape = new Shape();
			_bgShape.graphics.beginFill(15262671,1);
			_bgShape.graphics.drawRoundRect(0,0,327,328,2,2);
			_bgShape.graphics.endFill();
			_bgShape.x = 10;
			_bgShape.y = 80;
			addChild(this.BG);
			addChild(_bgShape);
			addChild(this._bank);
			addChild(this.title);
			addChild(this.smallBg);
		}
		
		override protected function initBagList() : void
		{
			this._equiplist = new BagEquipListView(0,31,79,7,_equipBagPage);
			this._proplist = new BagProListView(1,0,48);
			PositionUtils.setPos(_equiplist,"consortion.bank.listPos");
			PositionUtils.setPos(_proplist,"consortion.bank.listPos");
			var _loc1_:* = LIST_WIDTH;
			_proplist.width = _loc1_;
			_equiplist.width = _loc1_;
			_loc1_ = LIST_HEIGHT;
			_proplist.height = _loc1_;
			_equiplist.height = _loc1_;
			_proplist.visible = false;
			_lists = [_equiplist,_proplist];
			_currentList = _equiplist;
			addChild(_equiplist);
			addChild(_proplist);
		}
		
		override protected function __listChange(param1:Event) : void
		{
			if(param1.currentTarget == _equiplist)
			{
				setBagType(0);
			}
			else
			{
				setBagType(1);
			}
		}
		
		override protected function __cellDoubleClick(param1:CellEvent) : void
		{
			SoundManager.instance.play("008");
			var _loc3_:int = this._bank.checkConsortiaStoreCell();
			if(_loc3_ > 0)
			{
				if(_loc3_ == 3)
				{
					MessageTipManager.getInstance().show("test11");
				}
				return;
			}
			if(PlayerManager.Instance.Self.bagLocked)
			{
				BaglockedManager.Instance.show();
				return;
			}
			param1.stopImmediatePropagation();
			var _loc4_:BagCell = param1.data as BagCell;
			var _loc6_:InventoryItemInfo = _loc4_.info as InventoryItemInfo;
			var _loc5_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc6_.TemplateID);
			var _loc2_:int = !!PlayerManager.Instance.Self.Sex ? int(1) : int(2);
			if(!_loc4_.locked)
			{
				SocketManager.Instance.out.sendMoveGoods(_loc6_.BagType,_loc6_.Place,51,-1);
			}
		}
		
		override protected function ___trieveBtnClick(param1:MouseEvent) : void
		{
			super.___trieveBtnClick(param1);
			RetrieveController.Instance.isBagOpen = false;
		}
		
		private function __bankCellClick(param1:CellEvent) : void
		{
			var _loc2_:* = null;
			var _loc3_:* = null;
			if(!_sellBtn.isActive)
			{
				param1.stopImmediatePropagation();
				_loc2_ = param1.data as BagCell;
				if(_loc2_)
				{
					_loc3_ = _loc2_.info as InventoryItemInfo;
				}
				if(_loc3_ == null)
				{
					return;
				}
				if(!_loc2_.locked)
				{
					SoundManager.instance.play("008");
					_loc2_.dragStart();
				}
			}
		}
		
		private function __bankCellDoubleClick(param1:CellEvent) : void
		{
			SoundManager.instance.play("008");
			param1.stopImmediatePropagation();
			if(PlayerManager.Instance.Self.bagLocked)
			{
				BaglockedManager.Instance.show();
				return;
			}
			var _loc2_:BagCell = param1.data as BagCell;
			var _loc3_:InventoryItemInfo = _loc2_.itemInfo;
			SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,this.getItemBagType(_loc3_),-1,_loc3_.Count);
		}
		
		private function getItemBagType(param1:InventoryItemInfo) : int
		{
			if(param1 && (param1.CategoryID == 10 || param1.CategoryID == 11 || param1.CategoryID == 12 || param1.CategoryID == 20 || param1.CategoryID == 23))
			{
				return 1;
			}
			return 0;
		}
		
		public function setData(param1:SelfInfo) : void
		{
			_equiplist.setData(param1.Bag);
			_proplist.setData(param1.PropBag);
			this._bank.setData(param1.BankBag);
		}
		
		override protected function __cellClick(param1:CellEvent) : void
		{
			var _loc2_:* = null;
			var _loc4_:* = null;
			var _loc3_:* = null;
			if(!_sellBtn.isActive)
			{
				param1.stopImmediatePropagation();
				_loc2_ = param1.data as BagCell;
				if(_loc2_)
				{
					_loc4_ = _loc2_.info as InventoryItemInfo;
				}
				if(_loc4_ == null)
				{
					return;
				}
				if(!_loc2_.locked)
				{
					SoundManager.instance.play("008");
					if(_loc4_.getRemainDate() <= 0 && !EquipType.isProp(_loc4_) || EquipType.isPackage(_loc4_) || _loc4_.getRemainDate() <= 0 && _loc4_.TemplateID == 10200 || EquipType.canBeUsed(_loc4_))
					{
						_loc3_ = localToGlobal(new Point(_loc2_.x,_loc2_.y));
						CellMenu.instance.show(_loc2_,_loc3_.x + 35,_loc3_.y + 107);
					}
					else
					{
						_loc2_.dragStart();
					}
				}
			}
		}
		
		override protected function __sortBagClick(param1:MouseEvent) : void
		{
			SoundManager.instance.play("008");
			var _loc2_:String = LanguageMgr.GetTranslation("bagAndInfo.consortionBag.sortBagClick.isSegistration");
			AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2).addEventListener("response",this.__frameEvent);
		}
		
		private function __frameEvent(param1:FrameEvent) : void
		{
			var _loc3_:BaseAlerFrame = param1.target as BaseAlerFrame;
			_loc3_.removeEventListener("response",this.__frameEvent);
			_loc3_.dispose();
			var _loc2_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.BANKBAG);
			switch(int(param1.responseCode))
			{
				case 0:
				case 1:
					PlayerManager.Instance.Self.PropBag.sortBag(3,_loc2_,0,_loc2_.items.length,false);
					break;
				case 2:
				case 3:
				case 4:
					PlayerManager.Instance.Self.PropBag.sortBag(3,_loc2_,0,_loc2_.items.length,true);
			}
		}
		
		override public function dispose() : void
		{
			super.dispose();
			if(this._bank)
			{
				this._bank.dispose();
			}
			this._bank = null;
			if(this.BG)
			{
				ObjectUtils.disposeObject(this.BG);
			}
			this.BG = null;
			if(this.title)
			{
				ObjectUtils.disposeObject(this.title);
			}
			this.title = null;
			if(this.smallBg)
			{
				ObjectUtils.disposeObject(this.smallBg);
			}
			this.smallBg = null;
			if(this.numBg)
			{
				ObjectUtils.disposeObject(this.numBg);
			}
			this.numBg = null;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}
