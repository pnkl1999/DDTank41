package lottery
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import ddt.view.tips.MultipleLineTip;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLVariables;
   import lottery.contorller.WaitingResultHandler;
   import lottery.data.LotteryCardResultVO;
   import lottery.data.LotteryModel;
   import lottery.data.LotteryResultAnalyzer;
   import lottery.data.LotteryWorldWagerAnalyzer;
   import lottery.view.CardLotteryHelpFrame;
   import lottery.view.CardLotteryResultFrame;
   import lottery.view.LuckyLotteryAwardFrame;
   import lottery.view.LuckyLotteryFailureFrame;
   import lottery.view.LuckyLotteryHelpFrame;
   
   public class LotteryContorller extends BaseStateView
   {
      
      private static const btnArray:Array = ["luckyLottery_btn","cardLottery_btn","luckyHelp_btn","cardHelp_btn","cardResult_btn"];
      
      private static const mcArray:Array = ["luckyLottery_mc","cardLottery_mc","luckyHelp_mc","cardHelp_mc","cardResult_mc"];
      
      private static const btnTipArray:Array = [LanguageMgr.GetTranslation("tank.lottery.luckyLottery.btnTip"),LanguageMgr.GetTranslation("tank.lottery.cardLottery.btnTip"),LanguageMgr.GetTranslation("tank.lottery.luckyHelp.btnTip"),LanguageMgr.GetTranslation("tank.lottery.cardHelp.btnTip"),LanguageMgr.GetTranslation("tank.lottery.cardResult.btnTip")];
       
      
      private var _hallAsset:MovieClip;
      
      private var _hallDesc:Bitmap;
      
      private var _worldWagerBg:Bitmap;
      
      private var _worldWagerField:GradientText;
      
      private var _btnMultiTips:MultipleLineTip;
      
      private var _btnTips:OneLineTip;
      
      private var _lotteryResultList:Vector.<LotteryCardResultVO>;
      
      private var _isShowResultFrame:Boolean;
      
      private var _waitHandler:WaitingResultHandler;
      
      private var _alphaGound:Sprite;
      
      public function LotteryContorller()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         this._hallAsset = ComponentFactory.Instance.creat("asset.lotteryHall.hallMainViewAsset");
         addChild(this._hallAsset);
         this._worldWagerField = ComponentFactory.Instance.creatComponentByStylename("lottery.worldWagerTxt");
         addChild(this._worldWagerField);
         this._worldWagerField.text = "";
         this._btnMultiTips = ComponentFactory.Instance.creatCustomObject("lottery.multipleLineTip");
         this._btnTips = ComponentFactory.Instance.creatCustomObject("lottery.oneLineTip");
         MainToolBar.Instance.show();
         this.loadWorldWager();
         this.loadLotteryResult();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         var _loc2_:int = 0;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKY_LOTTERY,this.__onLuckyLottery);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOTO_CARD_LOTTERY,this.__onGotoCardLottery);
         var _loc1_:int = 0;
         while(_loc1_ < btnArray.length)
         {
            _loc2_ = _loc1_;
            this._hallAsset[mcArray[_loc2_]].buttonMode = this._hallAsset[mcArray[_loc2_]].mouseEnable = this._hallAsset[mcArray[_loc2_]].mouseChildren = false;
            this._hallAsset[btnArray[_loc2_]].buttonMode = this._hallAsset[btnArray[_loc2_]].mouseEnable = this._hallAsset[btnArray[_loc2_]].mouseChildren = true;
            this._hallAsset[btnArray[_loc2_]].addEventListener(MouseEvent.CLICK,this.__onBtnClick);
            this._hallAsset[btnArray[_loc2_]].addEventListener(MouseEvent.MOUSE_OVER,this.__onBtnOver);
            this._hallAsset[btnArray[_loc2_]].addEventListener(MouseEvent.MOUSE_OUT,this.__onBtnOut);
            _loc1_++;
         }
      }
      
      private function removeEvent() : void
      {
         var _loc2_:int = 0;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKY_LOTTERY,this.__onLuckyLottery);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOTO_CARD_LOTTERY,this.__onGotoCardLottery);
         var _loc1_:int = 0;
         while(_loc1_ < btnArray.length)
         {
            _loc2_ = _loc1_;
            this._hallAsset[btnArray[_loc2_]].removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
            this._hallAsset[btnArray[_loc2_]].removeEventListener(MouseEvent.MOUSE_OVER,this.__onBtnOver);
            this._hallAsset[btnArray[_loc2_]].removeEventListener(MouseEvent.MOUSE_OUT,this.__onBtnOut);
            _loc1_++;
         }
      }
      
      private function loadWorldWager() : void
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("GetWorldWealth.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
         _loc2_.analyzer = new LotteryWorldWagerAnalyzer(this.onLoadWorldWagerComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      private function onLoadWorldWagerComplete(param1:LotteryWorldWagerAnalyzer) : void
      {
         this._worldWagerField.text = String(param1.worldWager);
      }
      
      private function loadLotteryResult() : void
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("QueryWealthDivineNum.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
         _loc2_.analyzer = new LotteryResultAnalyzer(this.onLoadLotteryResultComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      private function onLoadLotteryResultComplete(param1:LotteryResultAnalyzer) : void
      {
         this._lotteryResultList = param1.lotteryResultList;
         if(this._isShowResultFrame)
         {
            this.showLotteryResult();
         }
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
      }
      
      private function __onLuckyLottery(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Object = new Object();
         var _loc3_:int = param1.pkg.readInt();
         _loc2_["code"] = _loc3_;
         if(_loc3_ == 1)
         {
            _loc2_["TemplateId"] = param1.pkg.readInt();
            _loc2_["timeLimit"] = param1.pkg.readInt();
         }
         else if(_loc3_ == 3)
         {
            _loc2_["messageTip"] = param1.pkg.readUTF();
            this.onWaitResultComplete(_loc2_);
            return;
         }
         if(this._waitHandler)
         {
            this._waitHandler.setResult(_loc2_);
         }
         else
         {
            this.onWaitResultComplete(_loc2_);
         }
      }
      
      private function onWaitResultComplete(param1:*) : void
      {
         var _loc3_:LuckyLotteryAwardFrame = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = param1["code"];
         if(_loc2_ == 1)
         {
            _loc3_ = new LuckyLotteryAwardFrame();
            _loc3_.setInfo(param1["TemplateId"],param1["timeLimit"]);
            this.popupFrame(_loc3_);
         }
         else if(_loc2_ == 2)
         {
            this.popupFrame(new LuckyLotteryFailureFrame());
         }
         else
         {
            MessageTipManager.getInstance().show(param1["messageTip"]);
         }
         MovieClip(this._hallAsset["luckyLottery_mc"]).gotoAndPlay(1);
         this._hallAsset["luckyLottery_btn"].buttonMode = this._hallAsset["luckyLottery_btn"].mouseEnabled = this._hallAsset["luckyLottery_btn"].mouseChildren = true;
         if(this._alphaGound.parent)
         {
            this._alphaGound.parent.removeChild(this._alphaGound);
         }
         if(this._waitHandler)
         {
            this._waitHandler.dispose();
         }
         this._waitHandler = null;
      }
      
      private function __onGotoCardLottery(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:int = param1.pkg.readInt();
         LotteryModel.cardLotteryMoney = Number(_loc3_);
         StateManager.setState(StateType.LOTTERY_CARD);
      }
      
      private function luckLottery() : void
      {
         if(this._waitHandler)
         {
            this._waitHandler.dispose();
         }
         this._waitHandler = new WaitingResultHandler(2000,this.onWaitResultComplete);
         this._waitHandler.wait();
         if(this._alphaGound == null)
         {
            this._alphaGound = new Sprite();
            this._alphaGound.graphics.beginFill(0,0.001);
            this._alphaGound.graphics.drawRect(50,50,50,50);
            this._alphaGound.graphics.endFill();
         }
         LayerManager.Instance.addToLayer(this._alphaGound,LayerManager.GAME_TOP_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
         SocketManager.Instance.out.sendLuckLottery();
      }
      
      private function __onBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = mcArray[btnArray.indexOf(param1.currentTarget.name)];
         var _loc3_:MovieClip = MovieClip(this._hallAsset[_loc2_]);
         _loc3_.gotoAndPlay(3);
         switch(param1.currentTarget.name)
         {
            case "luckyLottery_btn":
               param1.currentTarget.buttonMode = param1.currentTarget.mouseEnabled = param1.currentTarget.mouseChildren = false;
               this.luckLottery();
               _loc3_.gotoAndStop(3);
               break;
            case "cardLottery_btn":
               SocketManager.Instance.out.gotoCardLottery();
               break;
            case "luckyHelp_btn":
               this.popupFrame(new LuckyLotteryHelpFrame());
               break;
            case "cardHelp_btn":
               this.popupFrame(new CardLotteryHelpFrame());
               break;
            case "cardResult_btn":
               this.showLotteryResult();
         }
      }
      
      private function __onBtnOver(param1:MouseEvent) : void
      {
         var _loc5_:OneLineTip = null;
         var _loc6_:Point = null;
         var _loc2_:int = btnArray.indexOf(param1.currentTarget.name);
         var _loc3_:String = mcArray[_loc2_];
         var _loc4_:MovieClip = MovieClip(this._hallAsset[_loc3_]);
         if(_loc3_ == "luckyLottery_mc")
         {
            if(_loc4_.currentFrame != 3)
            {
               _loc4_.gotoAndStop(2);
            }
         }
         else
         {
            _loc4_.gotoAndStop(2);
         }
         _loc5_ = this._btnTips;
         if(_loc3_ == "cardLottery_mc" || _loc3_ == "luckyLottery_mc")
         {
            _loc5_ = this._btnMultiTips;
         }
         _loc5_.tipData = btnTipArray[_loc2_];
         _loc5_.visible = true;
         LayerManager.Instance.addToLayer(_loc5_,LayerManager.GAME_TOP_LAYER);
         _loc6_ = DisplayObject(param1.currentTarget).localToGlobal(new Point(0,0));
         _loc5_.x = _loc6_.x;
         _loc5_.y = _loc6_.y - _loc5_.height;
      }
      
      private function __onBtnOut(param1:MouseEvent) : void
      {
         var _loc2_:String = mcArray[btnArray.indexOf(param1.currentTarget.name)];
         var _loc3_:MovieClip = MovieClip(this._hallAsset[_loc2_]);
         if(_loc2_ == "luckyLottery_mc")
         {
            if(_loc3_.currentFrame != 3)
            {
               _loc3_.gotoAndStop(1);
            }
         }
         else
         {
            _loc3_.gotoAndStop(1);
         }
         if(this._btnTips.parent)
         {
            this._btnTips.parent.removeChild(this._btnTips);
         }
         if(this._btnMultiTips.parent)
         {
            this._btnMultiTips.parent.removeChild(this._btnMultiTips);
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.removeEvent();
         if(this._hallAsset)
         {
            ObjectUtils.disposeObject(this._hallAsset);
         }
         this._hallAsset = null;
         if(this._worldWagerField)
         {
            ObjectUtils.disposeObject(this._worldWagerField);
         }
         this._worldWagerField = null;
         if(this._btnTips)
         {
            ObjectUtils.disposeObject(this._btnTips);
         }
         this._btnTips = null;
         if(this._btnMultiTips)
         {
            ObjectUtils.disposeObject(this._btnMultiTips);
         }
         this._btnMultiTips = null;
         super.leaving(param1);
      }
      
      public function showLotteryResult() : void
      {
         if(this._lotteryResultList == null)
         {
            this.loadLotteryResult();
            this._isShowResultFrame = true;
         }
         else
         {
            this.popupFrame(new CardLotteryResultFrame(this._lotteryResultList));
         }
      }
      
      private function popupFrame(param1:Sprite) : void
      {
         LayerManager.Instance.addToLayer(param1,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.LOTTERY_HALL;
      }
   }
}
