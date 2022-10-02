package surpriseRoulette.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.roulette.RouletteEvent;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import surpriseRoulette.manager.SurpriseRouletteTurn;
   
   public class SurpriseRouletteView extends Sprite implements Disposeable
   {
      
      public static const GLINT_ALL_GOODSTYPE:int = 5;
      
      public static const MAX_SELECTED:int = 8;
      
      private static const NUM:int = 18;
      
      public static const GLINT_ONE_TIME:int = 3000;
       
      
      private var _turnControl:SurpriseRouletteTurn;
      
      private var _bg:Bitmap;
      
      private var _bg1:Bitmap;
      
      private var _btnBuy:BaseButton;
      
      private var _btnStart:BaseButton;
      
      private var _btnClose:BaseButton;
      
      private var _tileSelected:SimpleTileList;
      
      private var _txtKeyCount:FilterFrameText;
      
      private var _txtNeedKey:FilterFrameText;
      
      private var _mcGreen:MovieClip;
      
      private var _mcBig:MovieClip;
      
      private var _pos:Array;
      
      private var _turnCount:int;
      
      private var _keyCount:int;
      
      private var _needKeyCount:Array;
      
      private var _isTurn:Boolean;
      
      private var _canClose:Boolean;
      
      private var _selectedItemType:int;
      
      private var _turnSlectedNumber:int = 0;
      
      private var _selectedCount:int;
      
      private var _list:Vector.<SurpriseRouletteCell>;
      
      private var _selectedList:Vector.<SurpriseRouletteCell>;
      
      private var _tidList:Array;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _musicVolumn:int;
      
      public function SurpriseRouletteView(param1:Array)
      {
         super();
         this._tidList = param1;
         this.init();
         this.initEvent();
      }
      
      public function get turnCount() : int
      {
         return this._turnCount;
      }
      
      public function set turnCount(param1:int) : void
      {
         this._turnCount = param1;
         this._txtNeedKey.text = this.needKeyCount.toString();
      }
      
      public function set keyCount(param1:int) : void
      {
         this._keyCount = param1;
         this._txtKeyCount.text = this._keyCount.toString();
      }
      
      public function get keyCount() : int
      {
         return this._keyCount;
      }
      
      public function get needKeyCount() : int
      {
         return this._needKeyCount[this.turnCount];
      }
      
      public function get isTurn() : Boolean
      {
         return this._isTurn;
      }
      
      public function set isTurn(param1:Boolean) : void
      {
         this._isTurn = param1;
         if(param1)
         {
            this._btnStart.enable = false;
            this._btnBuy.enable = false;
         }
         else
         {
            this._btnStart.enable = true;
            this._btnBuy.enable = true;
         }
      }
      
      public function set turnSlectedNumber(param1:int) : void
      {
         this._turnSlectedNumber = param1;
      }
      
      public function get turnSlectedNumber() : int
      {
         return this._turnSlectedNumber;
      }
      
      public function get canClose() : Boolean
      {
         return this._canClose;
      }
      
      private function init() : void
      {
         var _loc7_:SurpriseRouletteCell = null;
         var _loc3_:Rectangle = null;
         var _loc5_:Point = null;
         var _loc6_:Bitmap = null;
         _loc7_ = null;
         var _loc8_:BoxGoodsTempInfo = null;
         var _loc9_:InventoryItemInfo = null;
         var _loc10_:Bitmap = null;
         var _loc11_:SurpriseRouletteCell = null;
         this._musicVolumn = SharedManager.Instance.musicVolumn;
         SharedManager.Instance.musicVolumn = 0;
         SharedManager.Instance.changed();
         this._turnControl = new SurpriseRouletteTurn();
         this._pos = [];
         this._canClose = true;
         this._needKeyCount = [0,2,3,4,5,6,7,8,0];
         this._list = new Vector.<SurpriseRouletteCell>();
         this._selectedList = new Vector.<SurpriseRouletteCell>();
         var _loc1_:int = 0;
         while(_loc1_ < NUM)
         {
            _loc5_ = ComponentFactory.Instance.creatCustomObject("surpriseRoulette.pos" + _loc1_);
            this._pos.push(_loc5_);
            _loc1_++;
         }
         this._bg = ComponentFactory.Instance.creatBitmap("asset.awardSystem.surpriseRoulette.bg");
         this._mcGreen = ClassUtils.CreatInstance("asset.awardSystem.surpriseRoulette.green");
         this._mcGreen.stop();
         PositionUtils.setPos(this._mcGreen,"surpriseRoulette.posGreen");
         this._bg1 = ComponentFactory.Instance.creatBitmap("asset.awardSystem.surpriseRoulette.bg1");
         this._btnStart = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.start");
         this._btnBuy = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.buy");
         this._btnClose = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.close");
         this._txtKeyCount = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.txtKeyCount");
         this._txtNeedKey = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.txtNeedKey");
         this._mcBig = ClassUtils.CreatInstance("asset.awardSystem.surpriseRoulette.mcBig");
         this._mcBig.gotoAndStop(1);
         this._mcBig.mouseEnabled = false;
         this._mcBig.mouseChildren = false;
         PositionUtils.setPos(this._mcBig,"surpriseRoulette.posBig");
         addChild(this._bg);
         addChild(this._mcGreen);
         addChild(this._bg1);
         addChild(this._btnStart);
         addChild(this._btnBuy);
         addChild(this._btnClose);
         addChild(this._txtKeyCount);
         addChild(this._txtNeedKey);
         var _loc2_:int = 0;
         while(_loc2_ < NUM)
         {
            _loc6_ = ComponentFactory.Instance.creatBitmap("asset.awardSystem.surpriseRoulette.cellBg");
            _loc7_ = new SurpriseRouletteCell(_loc6_,-19,1);
            _loc7_.x = this._pos[_loc2_].x;
            _loc7_.y = this._pos[_loc2_].y;
            addChild(_loc7_);
            _loc8_ = this._tidList[_loc2_] as BoxGoodsTempInfo;
            _loc9_ = this.getTemplateInfo(_loc8_.TemplateId) as InventoryItemInfo;
            _loc9_.IsBinds = _loc8_.IsBind;
            _loc9_.ValidDate = _loc8_.ItemValid;
            _loc9_.IsJudge = true;
            _loc7_.info = _loc9_;
            _loc7_.count = _loc8_.ItemCount;
            this._list.push(_loc7_);
            _loc2_++;
         }
         _loc3_ = ComponentFactory.Instance.creatCustomObject("surpriseRoulette.rect");
         this._tileSelected = new SimpleTileList(4);
         this._tileSelected.hSpace = _loc3_.width;
         this._tileSelected.vSpace = _loc3_.height;
         this._tileSelected.x = _loc3_.x;
         this._tileSelected.y = _loc3_.y;
         var _loc4_:int = 0;
         while(_loc4_ < MAX_SELECTED)
         {
            _loc10_ = ComponentFactory.Instance.creatBitmap("asset.awardSystem.surpriseRoulette.selectedCellBg");
            _loc11_ = new SurpriseRouletteCell(_loc10_,-19,1);
            _loc11_.count = 0;
            this._tileSelected.addChild(_loc11_);
            this._selectedList.push(_loc11_);
            _loc4_++;
         }
         addChild(this._tileSelected);
         this.turnCount = 0;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM,this.__getItem);
         RouletteManager.instance.addEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE,this.__keyUpdate);
         this._turnControl.addEventListener(SurpriseRouletteTurn.COMPLETE,this.__turnComplete);
         this._btnStart.addEventListener(MouseEvent.CLICK,this._startClick);
         this._btnBuy.addEventListener(MouseEvent.CLICK,this._buyClick);
         this._btnClose.addEventListener(MouseEvent.CLICK,this._closeClick);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM,this.__getItem);
         RouletteManager.instance.removeEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE,this.__keyUpdate);
         this._turnControl.removeEventListener(SurpriseRouletteTurn.COMPLETE,this.__turnComplete);
         this._btnStart.removeEventListener(MouseEvent.CLICK,this._startClick);
         this._btnBuy.removeEventListener(MouseEvent.CLICK,this._buyClick);
         this._btnClose.removeEventListener(MouseEvent.CLICK,this._closeClick);
      }
      
      private function __getItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         this._selectedGoodsInfo = this.getTemplateInfo(_loc4_) as InventoryItemInfo;
         this._selectedGoodsInfo.StrengthenLevel = _loc2_.readInt();
         this._selectedGoodsInfo.AttackCompose = _loc2_.readInt();
         this._selectedGoodsInfo.DefendCompose = _loc2_.readInt();
         this._selectedGoodsInfo.LuckCompose = _loc2_.readInt();
         this._selectedGoodsInfo.AgilityCompose = _loc2_.readInt();
         this._selectedGoodsInfo.IsBinds = _loc2_.readBoolean();
         this._selectedGoodsInfo.ValidDate = _loc2_.readInt();
         this._selectedCount = _loc2_.readByte();
         this._selectedGoodsInfo.IsJudge = true;
         this._selectedItemType = _loc5_;
         this.turnSlectedNumber = this._findCellByItemID(_loc4_,this._selectedCount,this._selectedGoodsInfo.ValidDate,this._selectedGoodsInfo.IsBinds);
         if(this.turnSlectedNumber == -1)
         {
            this.isTurn = false;
         }
         else
         {
            this._turnControl.turnPlate(this._list,this.turnSlectedNumber);
            this._canClose = false;
         }
      }
      
      private function __keyUpdate(param1:RouletteEvent) : void
      {
         this.keyCount = param1.keyCount;
      }
      
      private function __turnComplete(param1:Event) : void
      {
         SoundManager.instance.play("126");
         this._mcGreen.stop();
         addChild(this._mcBig);
         this._mcBig.play();
         setTimeout(this.updateTurnList,GLINT_ONE_TIME);
      }
      
      private function updateTurnList() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = null;
         if(this._mcBig.parent)
         {
            removeChild(this._mcBig);
            this._mcBig.gotoAndStop(1);
         }
         _loc1_ = ClassUtils.CreatInstance("asset.awardSystem.surpriseRoulette.mcGetItem");
         _loc1_.x = this._tileSelected.x + this._selectedList[this.turnCount].x;
         _loc1_.y = this._tileSelected.y + this._selectedList[this.turnCount].y;
         var _loc2_:MovieClipWrapper = new MovieClipWrapper(_loc1_,true,true);
         addChild(_loc2_.movie);
         this._moveToSelctView();
         SoundManager.instance.play("125");
         this._canClose = true;
         ++this.turnCount;
         if(this._selectedItemType >= GLINT_ALL_GOODSTYPE)
         {
            SoundManager.instance.play("063");
         }
         this.isTurn = this.turnCount >= MAX_SELECTED ? Boolean(Boolean(true)) : Boolean(Boolean(false));
      }
      
      private function _moveToSelctView() : void
      {
         var _loc1_:Bitmap = null;
         _loc1_ = ComponentFactory.Instance.creat("asset.awardSystem.roulette.StopAsset");
         _loc1_.width = _loc1_.height = this._list[this.turnSlectedNumber].width;
         _loc1_.smoothing = true;
         _loc1_.x = this._list[this.turnSlectedNumber].x - this._list[this.turnSlectedNumber].width / 2;
         _loc1_.y = this._list[this.turnSlectedNumber].y - this._list[this.turnSlectedNumber].width / 2;
         addChild(_loc1_);
         this._list[this.turnSlectedNumber].visible = false;
         var _loc2_:SurpriseRouletteCell = this._list.splice(this.turnSlectedNumber,1)[0] as SurpriseRouletteCell;
         if(this.turnCount < MAX_SELECTED)
         {
            this._selectedList[this.turnCount].info = this._selectedGoodsInfo;
            this._selectedList[this.turnCount].count = this._selectedCount;
            _loc2_.dispose();
         }
      }
      
      private function _startClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this.isTurn)
         {
            if(this.needKeyCount <= this.keyCount)
            {
               this.isTurn = true;
               SocketManager.Instance.out.sendStartTurn();
               this._mcGreen.play();
            }
            else
            {
               RouletteManager.instance.showBuyRouletteKey(this._needKeyCount[this.turnCount],EquipType.SURPRISE_ROULETTE_KEY);
            }
         }
      }
      
      private function _buyClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = this._needKeyCount[this.turnCount] == 0 ? int(int(1)) : int(int(this._needKeyCount[this.turnCount]));
         RouletteManager.instance.showBuyRouletteKey(_loc2_,EquipType.SURPRISE_ROULETTE_KEY);
      }
      
      private function _closeClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(!this._canClose && this._turnCount < MAX_SELECTED)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.surpriseRoulette.quit"));
         }
         else
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.surpriseRoulette.close"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
         }
      }
      
      private function _response(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(param1.target);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dispose();
         }
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      private function _findCellByItemID(param1:int, param2:int, param3:int, param4:Boolean) : int
      {
         var _loc5_:int = 0;
         while(_loc5_ < this._list.length)
         {
            if(this._list[_loc5_].info.TemplateID == param1 && this._list[_loc5_].count == param2 && (this._list[_loc5_].info as InventoryItemInfo).ValidDate == param3 && (this._list[_loc5_].info as InventoryItemInfo).IsBinds == param4)
            {
               return _loc5_;
            }
            _loc5_++;
         }
         return -1;
      }
      
      private function _findSelectedGoodsNumberInTemplateIDList(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._tidList.length)
         {
            if(this._tidList[_loc3_].TemplateId == param1 && this._tidList[_loc3_].ItemCount == param2)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function dispose() : void
      {
         SharedManager.Instance.musicVolumn = this._musicVolumn;
         SharedManager.Instance.changed();
         SocketManager.Instance.out.sendFinishRoulette();
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(this._turnControl)
         {
            this._turnControl.dispose();
            this._turnControl = null;
         }
         this._bg = null;
         this._bg1 = null;
         this._btnStart = null;
         this._btnBuy = null;
         this._btnClose = null;
         this._txtKeyCount = null;
         this._txtNeedKey = null;
         this._pos = null;
         this._needKeyCount = null;
         this._mcBig = null;
         this._mcGreen = null;
         this._tileSelected = null;
         this._list = null;
         this._selectedList = null;
         this._selectedGoodsInfo = null;
         this._tidList.splice(0,this._tidList.length);
         this._tidList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
