package store.forge
{
	import bagAndInfo.bag.RichesButton;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.core.Disposeable;
	import com.pickgliss.ui.image.Image;
	import com.pickgliss.ui.image.MutipleImage;
	import com.pickgliss.ui.image.ScaleFrameImage;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.events.PlayerPropertyEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import flash.display.Shape;
	import flash.display.Sprite;
	import store.StoreBagBgWHPoint;
	import store.view.storeBag.StoreBagbgbmp;
	
	public class ForgeRightBgView extends Sprite implements Disposeable
	{
		
		
		private var _bitmapBg:StoreBagbgbmp;
		
		private var bagBg:ScaleFrameImage;
		
		private var _equipmentsColumnBg:Image;
		
		private var _itemsColumnBg:Image;
		
		public var msg_txt:ScaleFrameImage;
		
		private var goldTxt:FilterFrameText;
		
		private var moneyTxt:FilterFrameText;
		
		private var giftTxt:FilterFrameText;
		
		private var _goldButton:RichesButton;
		
		private var _giftButton:RichesButton;
		
		private var _moneyButton:RichesButton;
		
		private var _bgPoint:StoreBagBgWHPoint;
		
		private var _bgShape:Shape;
		
		private var _equipmentTitleText:FilterFrameText;
		
		private var _itemTitleText:FilterFrameText;
		
		private var _equipmentTipText:FilterFrameText;
		
		private var _itemTipText:FilterFrameText;
		
		public function ForgeRightBgView()
		{
			super();
			this.initView();
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
		}
		
		public function equipmentTipText() : FilterFrameText
		{
			return this._equipmentTipText;
		}
		
		public function bgFrame(param1:int) : void
		{
			this.bagBg.setFrame(param1);
		}
		
		public function title1(param1:String) : void
		{
			this._equipmentTitleText.text = param1;
		}
		
		public function title2(param1:String) : void
		{
			this._itemTitleText.text = param1;
		}
		
		private function initView() : void
		{
			this._bitmapBg = new StoreBagbgbmp();
			addChildAt(this._bitmapBg,0);
			this.bagBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagViewBg2");
			this.bagBg.setFrame(1);
			addChild(this.bagBg);
			this._equipmentTitleText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.EquipmentTitleText");
			this._equipmentTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.EquipmentTitleText");
			this._itemTitleText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.ItemTitleText");
			this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
			this._equipmentTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.EquipmentTipText");
			this._itemTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.ItemTipText");
			addChild(this._equipmentTitleText);
			addChild(this._itemTitleText);
			addChild(this._equipmentTipText);
			addChild(this._itemTipText);
			var _loc1_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("store.ShowMoneyBG");
			addChild(_loc1_);
			this.moneyTxt = ComponentFactory.Instance.creatComponentByStylename("store.bagMoneyTxt");
			addChild(this.moneyTxt);
			this._goldButton = ComponentFactory.Instance.creatCustomObject("store.StoreBagView.GoldButton");
			this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
			addChild(this._goldButton);
			this.giftTxt = ComponentFactory.Instance.creatComponentByStylename("store.bagGiftTxt");
			addChild(this.giftTxt);
			this._giftButton = ComponentFactory.Instance.creatCustomObject("store.StoreBagView.GiftButton");
			this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections");
			addChild(this._giftButton);
			this._moneyButton = ComponentFactory.Instance.creatCustomObject("store.StoreBagView.MoneyButton");
			this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
			addChild(this._moneyButton);
			this.goldTxt = ComponentFactory.Instance.creatComponentByStylename("store.bagGoldTxt");
			addChild(this.goldTxt);
			this.updateMoney();
		}
		
		private function __propertyChange(param1:PlayerPropertyEvent) : void
		{
			if(param1.changedProperties["Money"] || param1.changedProperties["Gold"] || param1.changedProperties["Gift"])
			{
				this.updateMoney();
			}
		}
		
		public function showStoreBagViewText(param1:String, param2:String, param3:Boolean = true) : void
		{
			this._equipmentTipText.text = LanguageMgr.GetTranslation(param1);
			if(param3)
			{
				this._itemTipText.text = LanguageMgr.GetTranslation(param2);
			}
			this._itemTipText.visible = param3;
			this._itemTitleText.visible = param3;
		}
		
		private function updateMoney() : void
		{
			this.goldTxt.text = String(PlayerManager.Instance.Self.Gold);
			this.moneyTxt.text = String(PlayerManager.Instance.Self.Money);
			this.giftTxt.text = String(PlayerManager.Instance.Self.Gift);
		}
		
		public function hideMoney() : void
		{
			PlayerManager.Instance.Self.removeEventListener("propertychange",this.__propertyChange);
			ObjectUtils.disposeObject(this.goldTxt);
			ObjectUtils.disposeObject(this.moneyTxt);
			ObjectUtils.disposeObject(this.giftTxt);
			ObjectUtils.disposeObject(this._goldButton);
			ObjectUtils.disposeObject(this._giftButton);
			ObjectUtils.disposeObject(this._moneyButton);
		}
		
		public function dispose() : void
		{
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
			if(this.goldTxt)
			{
				ObjectUtils.disposeObject(this.goldTxt);
			}
			this.goldTxt = null;
			if(this.moneyTxt)
			{
				ObjectUtils.disposeObject(this.moneyTxt);
			}
			this.moneyTxt = null;
			if(this.giftTxt)
			{
				ObjectUtils.disposeObject(this.giftTxt);
			}
			this.giftTxt = null;
			if(this._goldButton)
			{
				ObjectUtils.disposeObject(this._goldButton);
			}
			this._goldButton = null;
			if(this._giftButton)
			{
				ObjectUtils.disposeObject(this._giftButton);
			}
			this._giftButton = null;
			if(this._moneyButton)
			{
				ObjectUtils.disposeObject(this._moneyButton);
			}
			this._moneyButton = null;
			ObjectUtils.disposeAllChildren(this);
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}
