package chickActivation.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   //import battleGroud.BattleGroudManager;
   import chickActivation.ChickActivationManager;
   import chickActivation.data.ChickActivationInfo;
   import chickActivation.event.ChickActivationEvent;
   import chickActivation.model.ChickActivationModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import shop.view.ShopPlayerCell;
   
   public class ChickActivationViewFrame extends Frame
   {
       
      
      private var _mainBg:Bitmap;
      
      private var _mainTitle:Bitmap;
      
      private var _helpTitle:Bitmap;
      
      private var _helpPanel:ScrollPanel;
      
      private var _helpTxt:FilterFrameText;
      
      private var _remainingTimeTxt:FilterFrameText;
      
      private var _group:SelectedButtonGroup;
      
      private var _selectBtn1:SelectedTextButton;
      
      private var _selectBtn2:SelectedTextButton;
      
      private var _groupTwo:SelectedButtonGroup;
      
      private var _selectEveryDay:SelectedButton;
      
      private var _selectWeekly:SelectedButton;
      
      private var _selectAfterThreeDays:SelectedButton;
      
      private var _selectLevelPacks:SelectedButton;
      
      private var _promptMovies:Array;
      
      private var _priceBitmap:Bitmap;
      
      private var _priceView:ChickActivationCoinsView;
      
      private var _moneyIcon:Bitmap;
      
      private var _lineBitmap1:Bitmap;
      
      private var _inputBg:Bitmap;
      
      private var _inputTxt:FilterFrameText;
      
      private var _activationBtn:BaseButton;
      
      private var _lineBitmap2:Bitmap;
      
      private var _receiveBtn:BaseButton;
      
      private var _levelPacks:ChickActivationLevelPacks;
      
      private var _ativationItems:ChickActivationItems;
      
      private var _clickRate:Number = 0;
      
      private var CHICKACTIVATION_CARDID:int = 201316;
      
      private var buyItemInfo:ShopItemInfo;
      
      public function ChickActivationViewFrame()
      {
         super();
         this.initView();
         this.updateView();
         this.tabHandler();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc2_:MovieClip = null;
         this._mainBg = ComponentFactory.Instance.creatBitmap("assets.chickActivation.mainBg");
         addToContent(this._mainBg);
         this._mainTitle = ComponentFactory.Instance.creatBitmap("assets.chickActivation.mainTitle");
         addToContent(this._mainTitle);
         this._helpTitle = ComponentFactory.Instance.creatBitmap("assets.chickActivation.helpTitle");
         addToContent(this._helpTitle);
         this._helpPanel = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.helpScroll");
         addToContent(this._helpPanel);
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.helpTxt");
         this._helpTxt.text = LanguageMgr.GetTranslation("tank.chickActivationFrame.helpTxtMsg");
         this._helpPanel.setView(this._helpTxt);
         this._helpPanel.invalidateViewport();
         this._remainingTimeTxt = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.remainingTimeTxt");
         this._remainingTimeTxt.htmlText = LanguageMgr.GetTranslation("tank.chickActivationFrame.remainingTimeTxtMsg",0);
         addToContent(this._remainingTimeTxt);
         this._selectBtn1 = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectBtn1");
         this._selectBtn1.text = LanguageMgr.GetTranslation("tank.chickActivationFrame.selectBtn1Txt");
         addToContent(this._selectBtn1);
         this._selectBtn2 = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectBtn2");
         this._selectBtn2.text = LanguageMgr.GetTranslation("tank.chickActivationFrame.selectBtn2Txt");
         addToContent(this._selectBtn2);
         this._group = new SelectedButtonGroup();
         this._group.addSelectItem(this._selectBtn1);
         this._group.addSelectItem(this._selectBtn2);
         this._group.selectIndex = 0;
         this._selectEveryDay = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectEveryDay");
         addToContent(this._selectEveryDay);
         this._selectWeekly = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectWeekly");
         addToContent(this._selectWeekly);
         this._selectAfterThreeDays = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectAfterThreeDays");
         addToContent(this._selectAfterThreeDays);
         this._selectLevelPacks = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectLevelPacks");
         addToContent(this._selectLevelPacks);
         this._groupTwo = new SelectedButtonGroup();
         this._groupTwo.addSelectItem(this._selectEveryDay);
         this._groupTwo.addSelectItem(this._selectWeekly);
         this._groupTwo.addSelectItem(this._selectAfterThreeDays);
         this._groupTwo.addSelectItem(this._selectLevelPacks);
         this._groupTwo.selectIndex = 0;
         this._promptMovies = [];
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = ClassUtils.CreatInstance("assets.chickActivation.promptMovie");
            PositionUtils.setPos(_loc2_,"chickActivation.promptMoviePos" + _loc1_);
            _loc2_.mouseChildren = false;
            _loc2_.mouseEnabled = false;
            _loc2_.visible = false;
            addToContent(_loc2_);
            this._promptMovies.push(_loc2_);
            _loc1_++;
         }
         this._priceBitmap = ComponentFactory.Instance.creatBitmap("assets.chickActivation.priceBitmap");
         addToContent(this._priceBitmap);
         this._priceView = ComponentFactory.Instance.creatCustomObject("chickActivation.ChickActivationCoinsView");
         this._priceView.count = 0;
         addToContent(this._priceView);
         this._moneyIcon = ComponentFactory.Instance.creatBitmap("assets.chickActivation.moneyIcon");
         addToContent(this._moneyIcon);
         this._lineBitmap1 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.lineBitmap");
         PositionUtils.setPos(this._lineBitmap1,"chickActivation.lineBitmapPos1");
         addToContent(this._lineBitmap1);
         this._inputBg = ComponentFactory.Instance.creatBitmap("assets.chickActivation.inputBg");
         addToContent(this._inputBg);
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("chickActivation.inputTxt");
         this._inputTxt.text = LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg");
         addToContent(this._inputTxt);
         this._activationBtn = ComponentFactory.Instance.creatComponentByStylename("chickActivation.activationBtn");
         addToContent(this._activationBtn);
         this._lineBitmap2 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.lineBitmap");
         PositionUtils.setPos(this._lineBitmap2,"chickActivation.lineBitmapPos2");
         addToContent(this._lineBitmap2);
         this._receiveBtn = ComponentFactory.Instance.creatComponentByStylename("chickActivation.receiveBtn");
         addToContent(this._receiveBtn);
         this._ativationItems = ComponentFactory.Instance.creatCustomObject("chickActivation.ativationItems");
         addToContent(this._ativationItems);
         this._levelPacks = ComponentFactory.Instance.creatCustomObject("chickActivation.ChickActivationLevelPacks");
         this._levelPacks.visible = false;
         addToContent(this._levelPacks);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._group.addEventListener(Event.CHANGE,this.__selectBtnHandler);
         this._groupTwo.addEventListener(Event.CHANGE,this.__selectBtnTwoHandler);
         this._inputTxt.addEventListener(MouseEvent.CLICK,this.__inputTxtHandler);
         this._activationBtn.addEventListener(MouseEvent.CLICK,this.__activationBtnHandler);
         this._receiveBtn.addEventListener(MouseEvent.CLICK,this.__receiveBtnHandler);
         this._levelPacks.addEventListener(ChickActivationEvent.CLICK_LEVELPACKS,this.__clickLevelPacksHandler);
         ChickActivationManager.instance.model.addEventListener(ChickActivationEvent.UPDATE_DATA,this.__updateDataHandler);
         ChickActivationManager.instance.model.addEventListener(ChickActivationEvent.GET_REWARD,this.__getRewardHandler);
      }
      
      private function __updateDataHandler(param1:ChickActivationEvent) : void
      {
         this.updateView();
      }
      
      private function updateView() : void
      {
         var _loc1_:ChickActivationModel = ChickActivationManager.instance.model;
         var _loc2_:int = ChickActivationManager.instance.model.getRemainingDay();
         if(PlayerManager.Instance.Self.Grade > 10 && _loc1_.keyOpenedType != 1 || _loc1_.keyOpenedType == 1 && _loc2_ <= 0)
         {
            this._selectBtn1.enable = false;
            this._group.selectIndex = 1;
         }
         this._remainingTimeTxt.htmlText = LanguageMgr.GetTranslation("tank.chickActivationFrame.remainingTimeTxtMsg",_loc2_);
         this.updateShine();
         this.updateGetBtn();
         this._levelPacks.update();
         this.showBottomActivationButton();
      }
      
      private function updateShine() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:int = 0;
         var _loc1_:Array = ChickActivationManager.instance.model.gainArr;
         var _loc2_:int = ChickActivationManager.instance.model.getRemainingDay();
         if(ChickActivationManager.instance.model.isKeyOpened > 0 && ChickActivationManager.instance.model.keyOpenedType == this._group.selectIndex + 1 && _loc2_ > 0)
         {
            if(_loc1_ && _loc1_.length > 0)
            {
               _loc5_ = TimeManager.Instance.Now().day;
               if(_loc5_ == 0)
               {
                  _loc5_ = 7;
               }
               _loc3_ = _loc5_ - 1;
               _loc6_ = _loc1_[_loc3_];
               if(_loc6_ <= 0)
               {
                  _loc7_ = true;
               }
               MovieClip(this._promptMovies[0]).visible = _loc7_;
               MovieClip(this._promptMovies[1]).visible = _loc1_[10] <= 0;
               if(_loc5_ == 5)
               {
                  _loc3_ = 7;
               }
               else if(_loc5_ == 6)
               {
                  _loc3_ = 8;
               }
               else if(_loc5_ == 7)
               {
                  _loc3_ = 9;
               }
               if(_loc3_ > 6)
               {
                  _loc9_ = _loc1_[_loc3_];
                  if(_loc9_ <= 0)
                  {
                     _loc8_ = true;
                  }
               }
               MovieClip(this._promptMovies[2]).visible = _loc8_;
               if(this._group.selectIndex == 0)
               {
                  _loc10_ = -1;
                  _loc11_ = PlayerManager.Instance.Self.Grade;
                  _loc12_ = 0;
                  while(_loc12_ < this._levelPacks.packsLevelArr.length)
                  {
                     if(this._levelPacks.packsLevelArr[_loc12_].level <= _loc11_)
                     {
                        _loc10_ = _loc12_;
                     }
                     _loc12_++;
                  }
                  if(_loc10_ == -1)
                  {
                     MovieClip(this._promptMovies[3]).visible = false;
                  }
                  _loc13_ = 0;
                  while(_loc13_ <= _loc10_)
                  {
                     _loc14_ = ChickActivationManager.instance.model.getGainLevel(_loc13_ + 1);
                     if(!_loc14_)
                     {
                        _loc4_ = true;
                        break;
                     }
                     _loc13_++;
                  }
                  MovieClip(this._promptMovies[3]).visible = _loc4_;
               }
               else
               {
                  MovieClip(this._promptMovies[3]).visible = false;
               }
            }
         }
         else
         {
            _loc15_ = 0;
            while(_loc15_ < this._promptMovies.length)
            {
               MovieClip(this._promptMovies[_loc15_]).visible = false;
               _loc15_++;
            }
         }
      }
      
      private function updateGetBtn() : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = ChickActivationManager.instance.model.getRemainingDay();
         if(ChickActivationManager.instance.model.isKeyOpened > 0 && ChickActivationManager.instance.model.keyOpenedType == this._group.selectIndex + 1 && _loc1_ > 0)
         {
            _loc2_ = ChickActivationManager.instance.model.gainArr;
            _loc3_ = this.getNowGainArrIndex();
            if(_loc2_.hasOwnProperty(_loc3_))
            {
               _loc4_ = _loc2_[_loc3_];
               if(_loc4_ > 0)
               {
                  this._receiveBtn.enable = false;
               }
               else
               {
                  this._receiveBtn.enable = true;
               }
            }
            else
            {
               this._receiveBtn.enable = false;
            }
         }
         else
         {
            this._receiveBtn.enable = false;
         }
      }
      
      private function getNowGainArrIndex() : int
      {
         var _loc1_:int = TimeManager.Instance.Now().day;
         var _loc2_:int = -1;
         if(_loc1_ == 0)
         {
            _loc1_ = 7;
         }
         if(this._groupTwo.selectIndex == 0)
         {
            _loc2_ = _loc1_ - 1;
         }
         else if(this._groupTwo.selectIndex == 2)
         {
            if(_loc1_ == 5)
            {
               _loc2_ = 7;
            }
            else if(_loc1_ == 6)
            {
               _loc2_ = 8;
            }
            else if(_loc1_ == 7)
            {
               _loc2_ = 9;
            }
         }
         else if(this._groupTwo.selectIndex == 1)
         {
            _loc2_ = 10;
         }
         return _loc2_;
      }
      
      private function __getRewardHandler(param1:ChickActivationEvent) : void
      {
         var _loc2_:int = param1.resultData as int;
         if(_loc2_ == 11)
         {
            return;
         }
         var _loc3_:String = "" + (ChickActivationManager.instance.model.keyOpenedType - 1);
         var _loc4_:int = ChickActivationManager.instance.model.keyOpenedType;
         if(_loc2_ < 7)
         {
            _loc3_ += ",0,1";
         }
         else if(_loc2_ < 10)
         {
            _loc3_ += ",2,5";
         }
         else if(_loc2_ < 11)
         {
            _loc3_ += ",1";
         }
         var _loc5_:int = ChickActivationManager.instance.model.qualityDic[_loc3_];
         var _loc6_:Array = ChickActivationManager.instance.model.itemInfoList[_loc5_];
         if(_loc6_)
         {
            this.playDropGoodsMovie(_loc6_);
         }
      }
      
      private function __selectBtnHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._groupTwo.selectIndex = 0;
         this.tabHandler();
         this.updateShine();
         this.showBottomActivationButton();
      }
      
      private function __selectBtnTwoHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.tabHandler();
      }
      
      private function tabHandler() : void
      {
         this._ativationItems.visible = false;
         this._levelPacks.visible = false;
         this.showBottomPriceAndButton(true);
         this.updateGetBtn();
         this._selectLevelPacks.visible = this._group.selectIndex == 0;
         var _loc1_:int = this._groupTwo.selectIndex;
         if(_loc1_ == 0)
         {
            this.findDataUpdateActivationItems();
            this.updatePriceView();
            this._ativationItems.visible = true;
         }
         else if(_loc1_ == 1)
         {
            this.findDataUpdateActivationItems();
            this.updatePriceView();
            this._ativationItems.visible = true;
         }
         else if(_loc1_ == 2)
         {
            this.findDataUpdateActivationItems();
            this.updatePriceView();
            this._ativationItems.visible = true;
         }
         else if(_loc1_ == 3)
         {
            this._levelPacks.update();
            this._levelPacks.visible = true;
            this.updatePriceView();
         }
      }
      
      private function updatePriceView() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:ChickActivationInfo = null;
         var _loc2_:int = ChickActivationManager.instance.model.findQualityValue(this.getQualityKey());
         if(ChickActivationManager.instance.model.itemInfoList.hasOwnProperty(_loc2_))
         {
            _loc3_ = ChickActivationManager.instance.model.itemInfoList[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = ChickActivationInfo(_loc3_[_loc4_]);
               _loc1_ += _loc5_.Probability;
               _loc4_++;
            }
         }
         if(this._priceView)
         {
            this._priceView.count = _loc1_;
         }
      }
      
      private function findDataUpdateActivationItems() : void
      {
         var _loc4_:Array = null;
         var _loc1_:Array = ChickActivationManager.instance.model.itemInfoList;
         var _loc2_:Dictionary = ChickActivationManager.instance.model.qualityDic;
         var _loc3_:int = ChickActivationManager.instance.model.findQualityValue(this.getQualityKey());
         if(_loc1_.hasOwnProperty(_loc3_))
         {
            _loc4_ = _loc1_[_loc3_];
            this._ativationItems.update(_loc4_);
         }
         else
         {
            this._ativationItems.update(null);
         }
      }
      
      private function showBottomPriceAndButton(param1:Boolean) : void
      {
         this._priceBitmap.visible = param1;
         this._moneyIcon.visible = param1;
         this._lineBitmap1.visible = param1;
         this._priceView.visible = param1;
         this._lineBitmap2.visible = param1;
         this._receiveBtn.visible = param1;
      }
      
      private function showBottomActivationButton() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:ChickActivationModel = ChickActivationManager.instance.model;
         var _loc3_:int = ChickActivationManager.instance.model.getRemainingDay();
         if(this._group.selectIndex == 0)
         {
            if(_loc2_.keyOpenedType == 0 && PlayerManager.Instance.Self.Grade <= 10 || _loc2_.keyOpenedType == 1 && _loc3_ <= 0)
            {
               _loc1_ = true;
            }
            else
            {
               _loc1_ = false;
            }
         }
         else if(this._group.selectIndex == 1)
         {
            if(_loc2_.keyOpenedType == 0 && PlayerManager.Instance.Self.Grade > 10 || _loc2_.keyOpenedType == 2 && _loc3_ <= 0)
            {
               _loc1_ = true;
            }
            else
            {
               _loc1_ = false;
            }
         }
         this._inputBg.visible = _loc1_;
         this._inputTxt.visible = _loc1_;
         this._activationBtn.visible = _loc1_;
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __inputTxtHandler(param1:MouseEvent) : void
      {
         if(this._inputTxt.text == LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg"))
         {
            this._inputTxt.text = "";
         }
      }
      
      private function __activationBtnHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = this._inputTxt.text;
         if(this._inputTxt.text == "" || this._inputTxt.text == LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg"))
         {
            this.showBuyFrame();
            return;
         }
         if(this._inputTxt.text.length != 14)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg2"));
            return;
         }
         if(this.clickRateGo())
         {
            return;
         }
         SocketManager.Instance.out.sendChickActivationOpenKey(_loc2_);
      }
      
      private function showBuyFrame() : void
      {
         var _loc1_:String = null;
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:AlertInfo = null;
         var _loc4_:FilterFrameText = null;
         var _loc5_:ShopPlayerCell = null;
         this.buyItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this.CHICKACTIVATION_CARDID);
         if(this.buyItemInfo)
         {
            _loc1_ = this.buyItemInfo.getItemPrice(1).toString();
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.buyChickActivationFrame");
            _loc2_.titleText = LanguageMgr.GetTranslation("tips");
            _loc3_ = new AlertInfo(LanguageMgr.GetTranslation("cancel"),LanguageMgr.GetTranslation("ok"));
            _loc2_.info = _loc3_;
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.contentTxt");
            _loc4_.text = LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg3",_loc1_);
            _loc2_.addToContent(_loc4_);
            _loc5_ = CellFactory.instance.createShopCartItemCell() as ShopPlayerCell;
            _loc5_.info = this.buyItemInfo.TemplateInfo;
            PositionUtils.setPos(_loc5_,"chickActivationFrame.ShopPlayerCellPos");
            _loc2_.addToContent(_loc5_);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__buyFrameResponse);
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __buyFrameResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__buyFrameResponse);
         ObjectUtils.disposeAllChildren(param1.currentTarget as DisplayObjectContainer);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc2_ = this.buyItemInfo.getItemPrice(1).moneyValue;
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendBuyGoods([this.buyItemInfo.GoodsID],[1],[""],[0],[Boolean(0)],[""],1,null,[false]);
         }
      }
      
      public function clickRateGo() : Boolean
      {
         var _loc1_:Number = new Date().time;
         if(_loc1_ - this._clickRate > 1000)
         {
            this._clickRate = _loc1_;
            return false;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.chickActivation.clickRateMsg"));
         return true;
      }
      
      private function __receiveBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.clickRateGo())
         {
            return;
         }
         if(ChickActivationManager.instance.model.isKeyOpened == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.chickActivation.receiveBtnMsg"));
            return;
         }
         var _loc2_:int = this.getNowGainArrIndex() + 1;
         SocketManager.Instance.out.sendChickActivationGetAward(_loc2_,0);
      }
      
      private function playDropGoodsMovie(param1:Array) : void
      {
         var _loc6_:InventoryItemInfo = null;
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("chickActivation.dropGoodsBeginPos");
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("chickActivation.dropGoodsEndPos");
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < this._ativationItems.arrData.length)
         {
            _loc6_ = ChickActivationManager.instance.model.getInventoryItemInfo(this._ativationItems.arrData[_loc5_]);
            if(_loc6_)
            {
               _loc4_.push(_loc6_);
            }
            _loc5_++;
         }
         DropGoodsManager.play(_loc4_,_loc2_,_loc3_,true);
      }
      
      private function getQualityKey() : String
      {
         var _loc4_:int = 0;
         var _loc1_:int = this._group.selectIndex;
         var _loc2_:int = this._groupTwo.selectIndex;
         var _loc3_:String = _loc1_ + "," + _loc2_;
         if(_loc2_ == 0)
         {
            _loc4_ = 1;
            _loc3_ += "," + _loc4_;
         }
         else if(_loc2_ == 2)
         {
            _loc4_ = 5;
            _loc3_ += "," + _loc4_;
         }
         return _loc3_;
      }
      
      private function __clickLevelPacksHandler(param1:ChickActivationEvent) : void
      {
         var _loc4_:int = 0;
         //var _loc5_:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.clickRateGo())
         {
            return;
         }
         var _loc2_:int = int(param1.resultData);
         var _loc3_:Array = ServerConfigManager.instance.chickenActiveKeyLvAwardNeedPrestige;
         if(_loc3_ && _loc3_.length > 0)
         {
            _loc4_ = _loc3_[_loc2_ - 1];
            //_loc5_ = BattleGroudManager.Instance.orderdata.totalPrestige;
            //if(_loc5_ < _loc4_)
            //{
            //   MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.chickActivation.totalPrestigeMsg",_loc4_));
            //   return;
            //}
         }
         SocketManager.Instance.out.sendChickActivationGetAward(12,_loc2_);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._group.removeEventListener(Event.CHANGE,this.__selectBtnHandler);
         this._groupTwo.removeEventListener(Event.CHANGE,this.__selectBtnTwoHandler);
         this._inputTxt.removeEventListener(MouseEvent.CLICK,this.__inputTxtHandler);
         this._activationBtn.removeEventListener(MouseEvent.CLICK,this.__activationBtnHandler);
         this._receiveBtn.removeEventListener(MouseEvent.CLICK,this.__receiveBtnHandler);
         this._levelPacks.removeEventListener(ChickActivationEvent.CLICK_LEVELPACKS,this.__clickLevelPacksHandler);
         ChickActivationManager.instance.model.removeEventListener(ChickActivationEvent.UPDATE_DATA,this.__updateDataHandler);
         ChickActivationManager.instance.model.removeEventListener(ChickActivationEvent.GET_REWARD,this.__getRewardHandler);
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._mainBg);
         this._mainBg = null;
         ObjectUtils.disposeObject(this._mainTitle);
         this._mainTitle = null;
         ObjectUtils.disposeObject(this._helpTitle);
         this._helpTitle = null;
         ObjectUtils.disposeObject(this._helpPanel);
         this._helpPanel = null;
         ObjectUtils.disposeObject(this._helpTxt);
         this._helpTxt = null;
         ObjectUtils.disposeObject(this._remainingTimeTxt);
         this._remainingTimeTxt = null;
         ObjectUtils.disposeObject(this._group);
         this._group = null;
         ObjectUtils.disposeObject(this._selectBtn1);
         this._selectBtn1 = null;
         ObjectUtils.disposeObject(this._selectBtn2);
         this._selectBtn2 = null;
         ObjectUtils.disposeObject(this._groupTwo);
         this._groupTwo = null;
         ObjectUtils.disposeObject(this._selectEveryDay);
         this._selectEveryDay = null;
         ObjectUtils.disposeObject(this._selectWeekly);
         this._selectWeekly = null;
         ObjectUtils.disposeObject(this._selectAfterThreeDays);
         this._selectAfterThreeDays = null;
         ObjectUtils.disposeObject(this._selectLevelPacks);
         this._selectLevelPacks = null;
         ObjectUtils.disposeObject(this._priceBitmap);
         this._priceBitmap = null;
         ObjectUtils.disposeObject(this._moneyIcon);
         this._moneyIcon = null;
         ObjectUtils.disposeObject(this._lineBitmap1);
         this._lineBitmap1 = null;
         ObjectUtils.disposeObject(this._inputBg);
         this._inputBg = null;
         ObjectUtils.disposeObject(this._inputTxt);
         this._inputTxt = null;
         ObjectUtils.disposeObject(this._activationBtn);
         this._activationBtn = null;
         ObjectUtils.disposeObject(this._lineBitmap2);
         this._lineBitmap2 = null;
         ObjectUtils.disposeObject(this._receiveBtn);
         this._receiveBtn = null;
         ObjectUtils.disposeObject(this._priceView);
         this._priceView = null;
         ObjectUtils.disposeObject(this._levelPacks);
         this._levelPacks = null;
         if(this._promptMovies)
         {
            _loc1_ = 0;
            while(_loc1_ < this._promptMovies.length)
            {
               this._promptMovies[_loc1_].stop();
               ObjectUtils.disposeObject(this._promptMovies[_loc1_]);
               _loc1_++;
            }
            this._promptMovies = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
