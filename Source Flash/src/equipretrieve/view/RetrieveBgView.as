package equipretrieve.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import equipretrieve.RetrieveController;
   import equipretrieve.RetrieveModel;
   import equipretrieve.effect.AnimationControl;
   import equipretrieve.effect.GlowFilterAnimation;
   import equipretrieve.effect.MovieClipControl;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import store.StoreCell;
   
   public class RetrieveBgView extends Sprite implements Disposeable
   {
       
      
      private var _retrieveBt:SelectedButton;
      
      private var _helpBt:SelectedButton;
      
      private var _needGoldText:FilterFrameText;
      
      private var _background:Bitmap;
      
      private var _dropArea:RetrieveDragInArea;
      
      private var _pointArray:Vector.<Point>;
      
      private var _cells:Vector.<StoreCell>;
      
      private var _moveCells:Vector.<StoreCell>;
      
      private var _tweenInt:int = 0;
      
      private var _retrieveBtLightBoo:Boolean;
      
      private var _startStrthTip:MutipleImage;
      
      private var _trieveShine:MovieImage;
      
      private var _effectMcArr:Vector.<MovieImage>;
      
      public function RetrieveBgView()
      {
         super();
         this._initView();
         this.addEvt();
      }
      
      public function _initView() : void
      {
         this._background = Bitmap(ComponentFactory.Instance.creatBitmap("equipretrieve.background"));
         this._retrieveBt = ComponentFactory.Instance.creatComponentByStylename("retrieve.retrieveBt");
         this._trieveShine = ComponentFactory.Instance.creatComponentByStylename("retrieve.trieveBtShine");
         this._trieveShine.mouseEnabled = false;
         this._trieveShine.mouseChildren = false;
         this._needGoldText = ComponentFactory.Instance.creatComponentByStylename("retrieve.needGold");
         this._helpBt = ComponentFactory.Instance.creatComponentByStylename("retrieve.helpBt");
         this._dropArea = new RetrieveDragInArea(this._cells);
         this._startStrthTip = ComponentFactory.Instance.creatComponentByStylename("trieve.ArrowHeadTip");
         addChild(this._background);
         this._getCellsPoint();
         this._buildCell();
         addChild(this._trieveShine);
         addChild(this._retrieveBt);
         addChild(this._helpBt);
         addChild(this._needGoldText);
         addChild(this._startStrthTip);
         this._retrieveBtLightBoo = false;
         this.hideArr();
      }
      
      private function _getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("equipretrieve.cellPoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function _buildCell() : void
      {
         var _loc1_:int = 0;
         var _loc2_:StoreCell = null;
         var _loc3_:StoreCell = null;
         _loc1_ = 0;
         _loc2_ = null;
         _loc3_ = null;
         this._cells = new Vector.<StoreCell>();
         this._moveCells = new Vector.<StoreCell>();
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            if(_loc1_ == 0)
            {
               _loc2_ = new RetrieveResultCell(_loc1_);
               _loc3_ = new RetrieveResultCell(_loc1_);
               addChild(_loc2_);
               addChild(_loc3_);
               addChild(this._dropArea);
            }
            else
            {
               _loc2_ = new RetrieveCell(_loc1_);
               _loc3_ = new RetrieveCell(_loc1_);
               addChild(_loc2_);
               addChild(_loc3_);
            }
            _loc3_.x = _loc2_.x = this._pointArray[_loc1_].x;
            _loc3_.y = _loc2_.y = this._pointArray[_loc1_].y;
            this._cells[_loc1_] = _loc2_;
            _loc3_.visible = false;
            _loc3_.BGVisible = false;
            this._moveCells[_loc1_] = _loc3_;
            RetrieveModel.Instance.setSaveCells(_loc2_,_loc1_);
            _loc1_++;
         }
      }
      
      public function startShine() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            this._cells[_loc1_].startShine();
            _loc1_++;
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            this._cells[_loc1_].stopShine();
            _loc1_++;
         }
      }
      
      private function addEvt() : void
      {
         this._helpBt.addEventListener(MouseEvent.CLICK,this.clickHelpBt);
         this._retrieveBt.addEventListener(MouseEvent.CLICK,this.executeRetrieve);
      }
      
      private function removeEvt() : void
      {
         this._helpBt.removeEventListener(MouseEvent.CLICK,this.clickHelpBt);
         this._retrieveBt.removeEventListener(MouseEvent.CLICK,this.executeRetrieve);
      }
      
      private function clickHelpBt(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:RetrieveHelpFrame = ComponentFactory.Instance.creatComponentByStylename("retrieve.helpFrame");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function showArr() : void
      {
         this._startStrthTip.visible = true;
         this._trieveShine.visible = true;
         this._trieveShine.movie.gotoAndPlay(1);
      }
      
      private function hideArr() : void
      {
         this._trieveShine.visible = false;
         this._trieveShine.movie.stop();
         this._startStrthTip.visible = false;
      }
      
      private function executeRetrieve(param1:MouseEvent) : void
      {
         var _loc5_:BaseAlerFrame = null;
         var _loc6_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:int = 1;
         while(_loc2_ < this._cells.length)
         {
            if(this._cells[_loc2_].info == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.equipretrieve.countlack"));
               return;
            }
            _loc2_++;
         }
         if(int(this._needGoldText.text) > PlayerManager.Instance.Self.Gold)
         {
            _loc5_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc5_.moveEnable = false;
            _loc5_.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return;
         }
         var _loc3_:int = 0;
         var _loc4_:int = 1;
         while(_loc4_ < this._cells.length)
         {
            if(this._cells[_loc4_].itemInfo.IsBinds == true)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         if(_loc3_ > 0 && _loc3_ < 4)
         {
            _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc6_.moveEnable = false;
            _loc6_.info.enableHtml = true;
            _loc6_.info.mutiline = true;
            _loc6_.addEventListener(FrameEvent.RESPONSE,this._bingResponse);
            return;
         }
         RetrieveController.Instance.viewMouseEvtBoolean = false;
         SocketManager.Instance.out.sendEquipRetrieve();
      }
      
      private function _bingResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._bingResponse);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            RetrieveController.Instance.viewMouseEvtBoolean = false;
            SocketManager.Instance.out.sendEquipRetrieve();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function _responseV(param1:FrameEvent) : void
      {
         var _loc2_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _loc2_.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1)
         {
            if(_loc2_ != "0")
            {
               _loc3_ = int(_loc2_);
               this._cells[_loc3_].info = PlayerManager.Instance.Self.StoreBag.items[_loc2_];
               if(!PlayerManager.Instance.Self.StoreBag.items["0"])
               {
                  RetrieveModel.Instance.setSaveInfo(PlayerManager.Instance.Self.StoreBag.items[_loc2_],_loc3_);
               }
            }
         }
         if(this._cells["1"].info && this._cells["2"].info && this._cells["3"].info && this._cells["4"].info)
         {
            this.showArr();
         }
         else
         {
            this.hideArr();
         }
         if(param1["0"] && PlayerManager.Instance.Self.StoreBag.items["0"])
         {
            this._moveCells[0].info = param1["0"];
            RetrieveModel.Instance.setSaveInfo(this._moveCells[0].itemInfo,0);
            if(this._moveCells[0].info && EquipType.isEquipBoolean(this._moveCells[0].info))
            {
               RetrieveController.Instance.retrieveType = 0;
            }
            else
            {
               RetrieveController.Instance.retrieveType = 1;
            }
            this._cellslightMovie();
         }
      }
      
      public function cellDoubleClick(param1:RetrieveBagcell) : void
      {
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         var _loc3_:int = 1;
         while(_loc3_ < this._cells.length)
         {
            if(this._cells[_loc3_].info == null)
            {
               SocketManager.Instance.out.sendMoveGoods(param1.bagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_);
               RetrieveModel.Instance.setSavePlaceType(_loc2_,_loc3_);
               return;
            }
            _loc3_++;
         }
         SocketManager.Instance.out.sendMoveGoods(param1.bagType,_loc2_.Place,BagInfo.STOREBAG,1);
         RetrieveModel.Instance.setSaveInfo(_loc2_,1);
         RetrieveModel.Instance.setSavePlaceType(_loc2_,1);
      }
      
      public function returnBag() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this._cells)
         {
            if(this._cells[_loc1_].info)
            {
               SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,int(_loc1_),int(!EquipType.isEquipBoolean(this._cells[_loc1_].info)),-1);
            }
         }
      }
      
      private function _cellslightMovie() : void
      {
         var _loc3_:GlowFilterAnimation = null;
         var _loc1_:AnimationControl = new AnimationControl();
         _loc1_.addEventListener(Event.COMPLETE,this._cellslightMovieOver);
         var _loc2_:int = 1;
         while(_loc2_ < this._moveCells.length)
         {
            this._moveCells[_loc2_].info = RetrieveModel.Instance.getSaveCells(_loc2_).info;
            this._moveCells[_loc2_].visible = true;
            _loc3_ = new GlowFilterAnimation();
            _loc3_.start(this._moveCells[_loc2_]);
            _loc3_.addMovie(0,0,4);
            _loc3_.addMovie(15,15,4);
            _loc3_.addMovie(15,15,2);
            _loc3_.addMovie(0,0,4);
            _loc3_.addMovie(0,0,2);
            _loc3_.addMovie(15,15,4);
            _loc3_.addMovie(15,15,2);
            _loc3_.addMovie(0,0,4);
            _loc1_.addMovies(_loc3_);
            _loc2_++;
         }
         SoundManager.instance.play("147");
         _loc1_.startMovie();
      }
      
      private function _cellslightMovieOver(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(Event.COMPLETE,this._cellslightMovieOver);
         this._cellsMove();
      }
      
      private function _cellsMove() : void
      {
         var _loc1_:TimelineLite = new TimelineLite({"onComplete":this._tweenlineComplete});
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:int = 1;
         while(_loc4_ < this._moveCells.length)
         {
            _loc2_.push(TweenLite.to(this._moveCells[_loc4_],0.3,{
               "x":this._moveCells[0].x + 12,
               "y":this._moveCells[0].y + 12
            }));
            _loc3_.push(TweenLite.to(this._moveCells[_loc4_],0.2,{
               "scaleX":0.5,
               "scaleY":0.5,
               "x":this._moveCells[0].x + 30,
               "y":this._moveCells[0].y + 30
            }));
            _loc4_++;
         }
         _loc1_.appendMultiple(_loc2_);
         _loc1_.appendMultiple(_loc3_);
      }
      
      private function _tweenlineComplete() : void
      {
         var _loc1_:int = 0;
         var _loc8_:TimelineLite = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         _loc1_ = 1;
         while(_loc1_ < this._moveCells.length)
         {
            this._moveCells[_loc1_].x = RetrieveModel.Instance.getSaveCells(_loc1_).oldx;
            this._moveCells[_loc1_].y = RetrieveModel.Instance.getSaveCells(_loc1_).oldy;
            this._moveCells[_loc1_].scaleX = this._moveCells[_loc1_].scaleY = 1;
            this._moveCells[_loc1_].visible = false;
            _loc1_++;
         }
         var _loc2_:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc0"));
         var _loc3_:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc1"));
         var _loc4_:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc2"));
         var _loc5_:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc3"));
         var _loc6_:MovieImage = MovieImage(ComponentFactory.Instance.creatComponentByStylename("effectmc4"));
         var _loc7_:MovieClipControl = new MovieClipControl(45);
         addChild(_loc2_);
         addChild(_loc3_);
         addChild(_loc4_);
         addChild(this._moveCells[0]);
         addChild(_loc5_);
         addChild(_loc6_);
         this._effectMcArr = new Vector.<MovieImage>();
         this._effectMcArr.push(_loc2_);
         this._effectMcArr.push(_loc3_);
         this._effectMcArr.push(_loc4_);
         this._effectMcArr.push(_loc5_);
         this._effectMcArr.push(_loc6_);
         _loc7_.addMovies(_loc2_.movie,1,_loc2_.movie.totalFrames);
         _loc7_.addMovies(_loc3_.movie,1,_loc3_.movie.totalFrames);
         _loc7_.addMovies(_loc4_.movie,1,_loc4_.movie.totalFrames);
         _loc7_.addMovies(_loc5_.movie,2,_loc5_.movie.totalFrames);
         _loc7_.addMovies(_loc6_.movie,5,_loc6_.movie.totalFrames);
         _loc7_.startMovie();
         _loc8_ = new TimelineLite({"onComplete":this._tweenline1Complete});
         this._moveCells[0].info = RetrieveModel.Instance.getSaveCells(0).info;
         this._moveCells[0].visible = true;
         this._moveCells[0].scaleX = this._moveCells[0].scaleY = 0.2;
         var _loc9_:Number = this._moveCells[0].x + this._moveCells[0].width / 2;
         _loc10_ = this._moveCells[0].y + this._moveCells[0].height / 2;
         _loc11_ = this._moveCells[0].width / 2;
         var _loc12_:Number = this._moveCells[0].height / 2;
         var _loc13_:Number = RetrieveModel.Instance.getresultCell().point.x - this.localToGlobal(new Point(this._moveCells[0].x,this._moveCells[0].y)).x + this._moveCells[0].x;
         var _loc14_:Number = RetrieveModel.Instance.getresultCell().point.y - this.localToGlobal(new Point(this._moveCells[0].x,this._moveCells[0].y)).y + this._moveCells[0].y;
         this._moveCells[0].scaleX = this._moveCells[0].scaleY = 0.2;
         this._moveCells[0].x = _loc9_ - 0.2 * _loc11_;
         this._moveCells[0].y = _loc10_ - 0.2 * _loc12_;
         _loc8_.append(TweenLite.to(this._moveCells[0],0.2,{
            "scaleX":0.2,
            "scaleY":0.2,
            "x":_loc9_ - 0.2 * _loc11_,
            "y":_loc10_ - 0.2 * _loc12_
         }));
         _loc8_.append(TweenLite.to(this._moveCells[0],0.2,{
            "scaleX":0.8,
            "scaleY":0.8,
            "x":_loc9_ - 0.8 * _loc11_,
            "y":_loc10_ - 0.8 * _loc12_
         }));
         _loc8_.append(TweenLite.to(this._moveCells[0],1.3,{
            "scaleX":0.8,
            "scaleY":0.8,
            "x":_loc9_ - 0.8 * _loc11_,
            "y":_loc10_ - 0.8 * _loc12_
         }));
         _loc8_.append(TweenLite.to(this._moveCells[0],0.2,{
            "scaleX":1.2,
            "scaleY":1.2,
            "x":_loc9_ - 1.2 * _loc11_,
            "y":_loc10_ - 1.2 * _loc12_
         }));
         _loc8_.append(TweenLite.to(this._moveCells[0],0.5,{
            "scaleX":0.5,
            "scaleY":0.5,
            "x":_loc13_,
            "y":_loc14_
         }));
      }
      
      private function _tweenline1Complete() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._effectMcArr.length)
         {
            if(this._effectMcArr[_loc1_])
            {
               ObjectUtils.disposeObject(this._effectMcArr[_loc1_]);
            }
            this._effectMcArr[_loc1_] = null;
            _loc1_++;
         }
         this._moveCells[0].x = RetrieveModel.Instance.getSaveCells(0).oldx;
         this._moveCells[0].y = RetrieveModel.Instance.getSaveCells(0).oldy;
         this._moveCells[0].scaleY = 1;
         this._moveCells[0].scaleX = 1;
         this._moveCells[0].visible = false;
         if(RetrieveModel.Instance.isFull == false)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.equipretrieve.success"));
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,0,RetrieveModel.Instance.getresultCell().bagType,RetrieveModel.Instance.getresultCell().place,1);
         }
         else
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,0,RetrieveModel.Instance.getresultCell().bagType,-1);
         }
         RetrieveController.Instance.viewMouseEvtBoolean = true;
      }
      
      public function dispose() : void
      {
         if(this._retrieveBt)
         {
            ObjectUtils.disposeObject(this._retrieveBt);
         }
         if(this._background)
         {
            ObjectUtils.disposeObject(this._background);
         }
         if(this._dropArea)
         {
            ObjectUtils.disposeObject(this._dropArea);
         }
         if(this._helpBt)
         {
            ObjectUtils.disposeObject(this._helpBt);
         }
         if(this._startStrthTip)
         {
            ObjectUtils.disposeObject(this._startStrthTip);
         }
         if(this._trieveShine)
         {
            ObjectUtils.disposeObject(this._trieveShine);
         }
         if(this._needGoldText)
         {
            ObjectUtils.disposeObject(this._needGoldText);
         }
         this._needGoldText = null;
         this._trieveShine = null;
         this._startStrthTip = null;
         this._pointArray = null;
         this._retrieveBt = null;
         this._helpBt = null;
         this._dropArea = null;
         this._background = null;
         this.returnBag();
         var _loc1_:int = 0;
         while(_loc1_ < this._cells.length)
         {
            if(this._cells[_loc1_])
            {
               ObjectUtils.disposeObject(this._cells[_loc1_]);
            }
            if(this._moveCells[_loc1_])
            {
               ObjectUtils.disposeObject(this._moveCells[_loc1_]);
            }
            this._moveCells[_loc1_] = null;
            this._cells[_loc1_] = null;
            _loc1_++;
         }
         this._cells = null;
         this._moveCells = null;
      }
   }
}
