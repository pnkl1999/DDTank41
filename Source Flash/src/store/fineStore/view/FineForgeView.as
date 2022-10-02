package store.fineStore.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   //import ddt.command.QuickBuyAlertBase;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.store.FineSuitVo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.FineSuitManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import road7th.comm.PackageIn;
   import store.fineStore.data.FineStorePackageType;
   
   public class FineForgeView extends Sprite implements Disposeable
   {
      private var _bg:Bitmap;
      
      private var _movieBg:MutipleImage;
      
      private var _infoBg:Bitmap;
      
      private var _titleBg:Bitmap;
      
      private var _progress:MovieClip;
      
      private var _progressText:FilterFrameText;
      
      private var _forgeBtn:BaseButton;
      
      private var _helpBtn:BaseButton;
      
      private var _select:SelectedCheckButton;
      
      private var _hBox:HBox;
      
      private var _materialList:Array;
      
      private var _effect:Sprite;
      
      private var _mouseOver:Sprite;
      
      private var _list:Array;
      
      private var _cell:Array;
      
      private var _index:int = 0;
      
      private var _butImage:Bitmap;
      
      private var _effectList:Array;
      
      private var _forgeAction:MovieClip;
      
      private var _cellAction:MovieClip;
      
      private var order:Array;
      
      private var _progressTips:Component;
      
      private var _efListSp:Sprite;
      
      private var _scroll:ScrollPanel;
      
      private var _forgeProgress:int;
      
      private var _timer:int;
      
      public function FineForgeView()
      {
         this.order = [0,1,2,3,4,5,11,13,12,16,9,10,7,8];
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc6_:ForgeEffectItem = null;
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:FineForgeCell = null;
         var _loc3_:BagCell = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         _loc6_ = null;
         var _loc7_:FilterFrameText = null;
         this._bg = UICreatShortcut.creatAndAdd("store.fineforge.forgeBg",this);
         this._movieBg = UICreatShortcut.creatAndAdd("newStore.fineStore.forgeMovieBg",this);
         this._infoBg = UICreatShortcut.creatAndAdd("store.fineforge.infoBg",this);
         this._titleBg = UICreatShortcut.creatAndAdd("store.fineforge.forgeTitle",this);
         this._progress = UICreatShortcut.creatAndAdd("store.fineforge.forgeProgress",this);
         this._progress.stop();
         PositionUtils.setPos(this._progress,"storeFine.forge.progressPos");
         this._progressTips = UICreatShortcut.creatAndAdd("storeFine.progress.tips",this);
         this._progressText = UICreatShortcut.creatTextAndAdd("ddtstore.info.StoreStrengthProgressText","0%",this._progressTips);
         this._forgeBtn = UICreatShortcut.creatAndAdd("storeFine.forge.forgeBtn",this);
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"ddtstore.HelpButton",null,LanguageMgr.GetTranslation("store.view.HelpButtonText"),"store.fineforge.forgeHelp",404,484);
         PositionUtils.setPos(this._helpBtn,"storeFine.forge.helpPos");
         this._select = UICreatShortcut.creatAndAdd("storeFine.forge.allInject",this);
         var _loc8_:Array = LanguageMgr.GetTranslation("storeFine.cell.titleText").split(",");
         this._cell = [];
         var _loc9_:int = 0;
         while(_loc9_ < 14)
         {
            _loc1_ = PlayerManager.Instance.Self.Bag.getItemAt(this.order[_loc9_]);
            _loc2_ = new FineForgeCell(1,_loc8_[_loc9_],_loc1_);
            _loc2_.addEventListener(MouseEvent.CLICK,this.__onClickCell);
            _loc2_.setContentSize(46,46);
            PositionUtils.setPos(_loc2_,"storeFine.cellPos" + _loc9_);
            addChild(_loc2_);
            this._cell.push(_loc2_);
            _loc9_++;
         }
         this.updateCellBgView();
         this._hBox = UICreatShortcut.creatAndAdd("storeFine.forge.hBox",this);
         addChild(this._hBox);
         this._materialList = [];
         var _loc10_:Array = FineSuitManager.Instance.materialIDList;
         var _loc11_:Bitmap = ComponentFactory.Instance.creatBitmap("store.fineforge.materialCellBg");
         _loc11_.visible = false;
         var _loc12_:int = this.needForgeCellId;
         _loc9_ = 0;
         while(_loc9_ < _loc10_.length)
         {
            _loc3_ = new BagCell(_loc9_,ItemManager.Instance.getTemplateById(_loc10_[_loc9_]),true,_loc11_);
            _loc3_.setContentSize(45,45);
            this.setForgeCellInfo(_loc3_,_loc12_);
            this._hBox.addChild(_loc3_);
            this._materialList.push(_loc3_);
            _loc9_++;
         }
         this._hBox.arrange();
         this.updateMaterialCount();
         this._butImage = UICreatShortcut.creatAndAdd("asset.horse.frame.buyBtn_small",this);
         this._butImage.visible = false;
         var _loc13_:Array = this.getTipsDataListView();
         var _loc14_:Array = LanguageMgr.GetTranslation("storeFine.suit.type").split(",");
         this._effect = new Sprite();
         addChild(this._effect);
         PositionUtils.setPos(this._effect,"storeFine.forge.effectPos");
         this._efListSp = new Sprite();
         var _loc15_:int = 0;
         this._effectList = [];
         _loc9_ = 0;
         while(_loc9_ < 5)
         {
            _loc4_ = LanguageMgr.GetTranslation("storeFine.effect.titleText",_loc14_[_loc9_]);
            _loc5_ = this.getforgeEffectState(_loc9_);
            _loc6_ = new ForgeEffectItem(_loc9_,_loc4_,_loc13_[_loc9_],_loc5_);
            this._efListSp.addChild(_loc6_);
            this._effect.addChild(_loc6_);
            this._effectList.push(_loc6_);
            _loc6_.y = _loc15_;
            _loc15_ = _loc6_.y + _loc6_.height - 3;
            _loc9_++;
         }
         this._scroll = ComponentFactory.Instance.creatComponentByStylename("storeFine.forge.effect.scrollpanel");
         this._scroll.setView(this._efListSp);
         this._scroll.invalidateViewport();
         this._effect.addChild(this._scroll);
         this._list = [];
         _loc9_ = 0;
         while(_loc9_ < 6)
         {
            _loc7_ = UICreatShortcut.creatAndAdd("storeFine.forge.infoText",this._effect);
            _loc7_.x = _loc9_ % 2 == 0 ? Number(Number(49)) : Number(Number(183));
            _loc7_.y = Math.ceil((_loc9_ + 1) / 2) * 23 + 270;
            this._list.push(_loc7_);
            _loc9_++;
         }
         this._mouseOver = new Sprite();
         PositionUtils.setPos(this._mouseOver,"forgeMainView.mouseOverPos");
         this._mouseOver.graphics.beginFill(0,0);
         this._mouseOver.graphics.drawRect(0,0,277,99);
         this._mouseOver.graphics.endFill();
         this._effect.addChild(this._mouseOver);
         this._mouseOver.addEventListener(MouseEvent.ROLL_OVER,this.onMOOver);
         this._mouseOver.addEventListener(MouseEvent.ROLL_OUT,this.onMOOut);
         this.updateInfo();
         this.updateSuitExp();
         this._forgeBtn.addEventListener(MouseEvent.CLICK,this.__onClickForgeBtn);
         this._forgeBtn.addEventListener(MouseEvent.ROLL_OVER,this.onMOOver);
         this._forgeBtn.addEventListener(MouseEvent.ROLL_OUT,this.onMOOut);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.STORE_FINE_SUITS,this.__onChangeSuitExp);
         PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdate);
      }
      
      protected function onMOOut(param1:MouseEvent) : void
      {
         this.updateInfo();
      }
      
      protected function onMOOver(param1:MouseEvent) : void
      {
         this.updateInfoOver();
      }
      
      private function updateInfoOver() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.fineSuitExp;
         var _loc2_:FineSuitVo = FineSuitManager.Instance.getNextLevelSuiteVo(_loc1_);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:FineSuitVo = FineSuitManager.Instance.getFineSuitPropertyByExp(_loc1_);
         var _loc4_:Array = [_loc3_.Defence,_loc3_.hp,_loc3_.Luck,_loc3_.Agility,_loc3_.MagicDefence,_loc3_.Armor];
         var _loc5_:Array = [_loc2_.Defence,_loc2_.hp,_loc2_.Luck,_loc2_.Agility,_loc2_.MagicDefence,_loc2_.Armor];
         var _loc6_:int = 0;
         while(_loc6_ < 6)
         {
            this._list[_loc6_].htmlText = (_loc4_[_loc6_] < 0 ? 0 : _loc4_[_loc6_]) + "<font color=\'#ff0000\'>+" + (_loc5_[_loc6_] < 0 ? 0 : _loc5_[_loc6_]) + "</font>";
            _loc6_++;
         }
      }
      
      private function __onCellClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         //var _loc2_:BagCell = param1.currentTarget as BagCell;
         //var _loc3_:ShopItemInfo = ShopManager.Instance.getGoodsByTemplateID(_loc2_.info.TemplateID);
         //var _loc4_:QuickBuyAlertBase = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickBuyAlert");
         //_loc4_.setData(_loc3_.TemplateID,_loc3_.GoodsID,_loc3_.AValue1);
         //LayerManager.Instance.addToLayer(_loc4_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onCellOver(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         this._butImage.visible = true;
         this._butImage.x = this._hBox.x + _loc2_.x + 2;
         this._butImage.y = this._hBox.y + 25;
      }
      
      private function __onCellOut(param1:MouseEvent) : void
      {
         this._butImage.visible = false;
      }
      
      private function forgeResultAction() : void
      {
         if(this._index == this.currentIndex)
         {
            this._forgeProgress = this.forgeProgress;
            if(this._forgeProgress > 100)
            {
               this._forgeProgress = 100;
            }
         }
         else
         {
            this._forgeProgress = 100;
         }
         this._progress.addEventListener(Event.ENTER_FRAME,this.__onProgressAction);
         this._progress.gotoAndPlay(this._progress.currentFrame);
         this._progress["star"].gotoAndStop(2);
      }
      
      private function __onProgressAction(param1:Event) : void
      {
         this._progressText.text = this._progress.currentFrame.toString() + "%";
         if(this._progress.currentFrame >= this._forgeProgress)
         {
            this._progress.removeEventListener(Event.ENTER_FRAME,this.__onProgressAction);
            this._progress.gotoAndStop(this._forgeProgress);
            this._progressText.text = this._forgeProgress.toString() + "%";
            this._progress["star"].gotoAndStop(1);
            if(this._forgeProgress == 100)
            {
               this.forgeSucceed();
            }
            else
            {
               this._forgeBtn.enable = true;
            }
         }
      }
      
      public function forgeSucceed() : void
      {
         var _loc1_:int = 0;
         if(!this._forgeAction)
         {
            this._forgeAction = UICreatShortcut.creatAndAdd("store.fineforge.forgeAction",this);
            this._forgeAction.addEventListener(Event.ENTER_FRAME,this.__onEnterForgeAction);
            _loc1_ = FineSuitManager.Instance.getSuitVoByExp(PlayerManager.Instance.Self.fineSuitExp).type;
            PositionUtils.setPos(this._forgeAction,"storeFine.actionPos" + _loc1_);
            this._forgeAction.gotoAndPlay(1);
         }
      }
      
      private function __onEnterForgeAction(param1:Event) : void
      {
         var _loc2_:Point = null;
         if(this._forgeAction.currentFrame == this._forgeAction.totalFrames - 1)
         {
            this._forgeAction.removeEventListener(Event.ENTER_FRAME,this.__onEnterForgeAction);
            this._forgeAction.gotoAndStop(this._forgeAction.totalFrames);
            _loc2_ = new Point(this.currentSelectedCell.x + this.currentSelectedCell.width / 2,this.currentSelectedCell.y + this.currentSelectedCell.height / 2);
            this._forgeAction.rotation = Math.atan2(_loc2_.y - this._forgeAction.y,_loc2_.x - this._forgeAction.x) * 180 / Math.PI + 90;
            TweenLite.to(this._forgeAction,1,{
               "x":_loc2_.x,
               "y":_loc2_.y,
               "onComplete":this.moveComplete
            });
         }
      }
      
      private function moveComplete() : void
      {
         var _loc1_:Point = null;
         this.disposeForgeAction();
         if(!this._cellAction)
         {
            _loc1_ = new Point(this.currentSelectedCell.x,this.currentSelectedCell.y);
            this._cellAction = UICreatShortcut.creatAndAdd("store.fineforge.cellBgAction",this);
            this._cellAction.addEventListener(Event.ENTER_FRAME,this.__onEnterCellAction);
            this._cellAction.gotoAndPlay(1);
            PositionUtils.setPos(this._cellAction,_loc1_);
         }
      }
      
      private function __onEnterCellAction(param1:Event) : void
      {
         if(this._cellAction.currentFrame == this._cellAction.totalFrames - 1)
         {
            this.disposeCellAction();
            this.updateCellBgView();
            this.updateSuitExp();
            this.updateInfo();
            this.updateTipsData();
            this._forgeBtn.enable = true;
         }
      }
      
      private function __onClickForgeBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(getTimer() - this._timer < 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         if(PlayerManager.Instance.Self.fineSuitExp == FineSuitManager.Instance.getSuitVoByLevel(70).exp)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("storeFine.accomplish"));
            return;
         }
         var _loc2_:int = FineSuitManager.Instance.getNextSuitVoByExp(PlayerManager.Instance.Self.fineSuitExp).materialID;
         var _loc3_:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(_loc2_);
         if(_loc3_ <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("storeFine.forgeTips"));
            return;
         }
         this._forgeBtn.enable = false;
         this._timer = getTimer();
         SocketManager.Instance.out.sendForgeSuit(!!this._select.selected ? int(0) : int(1));
      }
      
      private function __onClickCell(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.fineSuitExp == FineSuitManager.Instance.getSuitVoByLevel(70).exp)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("storeFine.accomplish"));
            return;
         }
         var _loc2_:FineForgeCell = param1.currentTarget as FineForgeCell;
         if(!_loc2_.selected)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("storeFine.cell.selectTips",this.currentSelectedCell.cellName));
         }
      }
      
      private function __onChangeSuitExp(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:Boolean = false;
         _loc2_ = param1.pkg;
         var _loc4_:int = _loc2_.readByte();
         switch(_loc4_)
         {
            case FineStorePackageType.FORGE_SUIT:
               _loc3_ = _loc2_.readBoolean();
               PlayerManager.Instance.Self.fineSuitExp = _loc2_.readInt();
               this.updateMaterialCount();
               if(_loc3_)
               {
                  this.forgeResultAction();
                  break;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("storeFine.forgeFail"));
               break;
         }
      }
      
      private function __onBagUpdate(param1:BagEvent) : void
      {
         this.updateMaterialCount();
      }
      
      private function updateInfo() : void
      {
         var _loc1_:FineSuitVo = FineSuitManager.Instance.getFineSuitPropertyByExp(PlayerManager.Instance.Self.fineSuitExp);
         var _loc2_:Array = [_loc1_.Defence,_loc1_.hp,_loc1_.Luck,_loc1_.Agility,_loc1_.MagicDefence,_loc1_.Armor];
         var _loc3_:int = 0;
         while(_loc3_ < 6)
         {
            this._list[_loc3_].text = _loc2_[_loc3_] < 0 ? 0 : _loc2_[_loc3_];
            _loc3_++;
         }
      }
      
      private function updateSuitExp() : void
      {
         var _loc1_:int = this.forgeProgress;
         this._progress.gotoAndStop(_loc1_);
         this._progressText.text = _loc1_ + "%";
      }
      
      private function updateMaterialCount() : void
      {
         var _loc1_:BagCell = null;
         var _loc2_:int = 0;
         var _loc3_:int = this.needForgeCellId;
         var _loc4_:int = 0;
         while(_loc4_ < this._materialList.length)
         {
            _loc1_ = this._materialList[_loc4_] as BagCell;
            _loc2_ = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(_loc1_.info.TemplateID);
            _loc1_.setCount(_loc2_);
            this.setForgeCellInfo(_loc1_,_loc3_);
            _loc4_++;
         }
      }
      
      private function updateCellBgView() : void
      {
         var _loc1_:FineForgeCell = null;
         var _loc2_:int = this.currentIndex;
         if(this._index == _loc2_ && this._index != 0)
         {
            return;
         }
         this._index = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < this._cell.length)
         {
            _loc1_ = this._cell[_loc3_] as FineForgeCell;
            _loc1_.bgType = _loc3_ < this._index ? int(int(2)) : int(int(1));
            _loc1_.selected = false;
            _loc3_++;
         }
         if(PlayerManager.Instance.Self.fineSuitExp != FineSuitManager.Instance.getSuitVoByLevel(70).exp)
         {
            this.currentSelectedCell.selected = true;
         }
      }
      
      private function updateTipsData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._effectList.length)
         {
            _loc1_ = this.getforgeEffectState(_loc2_);
            ForgeEffectItem(this._effectList[_loc2_]).updateTipData(_loc1_);
            _loc2_++;
         }
      }
      
      private function get currentSelectedCell() : FineForgeCell
      {
         return this._cell[this._index - 1] as FineForgeCell;
      }
      
      private function get currentIndex() : int
      {
         var _loc1_:int = FineSuitManager.Instance.getNextSuitVoByExp(PlayerManager.Instance.Self.fineSuitExp).level;
         _loc1_ = int(_loc1_ % 14);
         return _loc1_ == 0 ? int(int(14)) : int(int(_loc1_));
      }
      
      private function get needForgeCellId() : int
      {
         return int(FineSuitManager.Instance.getNextSuitVoByExp(PlayerManager.Instance.Self.fineSuitExp).materialID);
      }
      
      private function setForgeCellInfo(param1:BagCell, param2:int) : void
      {
         if(param1.info.TemplateID != param2)
         {
            param1.grayFilters = true;
            param1.removeEventListener(MouseEvent.CLICK,this.__onCellClick);
            param1.removeEventListener(MouseEvent.MOUSE_OVER,this.__onCellOver);
            param1.removeEventListener(MouseEvent.MOUSE_OUT,this.__onCellOut);
         }
         else
         {
            param1.grayFilters = false;
            param1.buttonMode = true;
            param1.addEventListener(MouseEvent.CLICK,this.__onCellClick);
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.__onCellOver);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.__onCellOut);
         }
      }
      
      private function get forgeProgress() : int
      {
         var _loc1_:int = PlayerManager.Instance.Self.fineSuitExp;
         var _loc2_:int = FineSuitManager.Instance.getSuitVoByExp(_loc1_).exp;
         var _loc3_:int = FineSuitManager.Instance.getNextSuitVoByExp(_loc1_).exp;
         this._progressTips.tipData = _loc1_ - _loc2_ + "/" + (_loc3_ - _loc2_);
         if(_loc2_ == _loc3_)
         {
            return 100;
         }
         return int((_loc1_ - _loc2_) / (_loc3_ - _loc2_) * 100);
      }
      
      private function getforgeEffectState(param1:int) : int
      {
         var _loc2_:int = FineSuitManager.Instance.getNextSuitVoByExp(PlayerManager.Instance.Self.fineSuitExp).level / 14;
         var _loc3_:int = -1;
         if(_loc2_ == 5)
         {
            _loc3_ = 1;
         }
         else if(_loc2_ < param1)
         {
            _loc3_ = 3;
         }
         else if(_loc2_ == param1)
         {
            _loc3_ = this.currentIndex == 14 ? int(int(3)) : int(int(2));
         }
         else if(_loc2_ == param1 + 1)
         {
            _loc3_ = this.currentIndex == 14 ? int(int(2)) : int(int(1));
         }
         else
         {
            _loc3_ = 1;
         }
         return _loc3_;
      }
      
      private function getTipsDataListView() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:int = 1;
         while(_loc2_ <= 5)
         {
            _loc1_.push(FineSuitManager.Instance.getTipsPropertyInfoList(_loc2_,"all"));
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function disposeForgeAction() : void
      {
         if(this._forgeAction)
         {
            TweenLite.killTweensOf(this._forgeAction);
            this._forgeAction.stop();
            this._forgeAction.removeEventListener(Event.ENTER_FRAME,this.__onEnterForgeAction);
            ObjectUtils.disposeObject(this._forgeAction);
            this._forgeAction = null;
         }
      }
      
      private function disposeCellAction() : void
      {
         if(this._cellAction)
         {
            this._cellAction.stop();
            this._cellAction.removeEventListener(Event.ENTER_FRAME,this.__onEnterCellAction);
            ObjectUtils.disposeObject(this._cellAction);
            this._cellAction = null;
         }
      }
      
      private function disposeProgressAction() : void
      {
         if(this._progress)
         {
            this._progress.stop();
            this._progress.removeEventListener(Event.ENTER_FRAME,this.__onProgressAction);
            ObjectUtils.disposeObject(this._progress);
            this._progress = null;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:FineForgeCell = null;
         var _loc2_:BagCell = null;
         this.disposeProgressAction();
         this.disposeForgeAction();
         this.disposeCellAction();
         ObjectUtils.disposeObject(this._progressText);
         this._progressText = null;
         if(this._mouseOver)
         {
            this._mouseOver.removeEventListener(MouseEvent.ROLL_OVER,this.onMOOver);
            this._mouseOver.removeEventListener(MouseEvent.ROLL_OUT,this.onMOOut);
            ObjectUtils.disposeObject(this._mouseOver);
            this._mouseOver = null;
         }
         ObjectUtils.disposeAllChildren(this._effect);
         for each(_loc1_ in this._cell)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__onClickCell);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._cell = null;
         while(this._hBox.numChildren)
         {
            _loc2_ = this._hBox.getChildAt(0) as BagCell;
            _loc2_.removeEventListener(MouseEvent.CLICK,this.__onCellClick);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.__onCellOver);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.__onCellOut);
            ObjectUtils.disposeObject(_loc2_);
         }
         this._forgeBtn.removeEventListener(MouseEvent.CLICK,this.__onClickForgeBtn);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.STORE_FINE_SUITS,this.__onChangeSuitExp);
         PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdate);
         ObjectUtils.disposeAllChildren(this);
         this._effectList = null;
         this._list = null;
         this._hBox = null;
      }
   }
}
