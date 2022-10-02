package gemstone.views
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import gemstone.GemstoneManager;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstonInitInfo;
   import gemstone.info.GemstoneStaticInfo;
   import gemstone.info.GemstoneUpGradeInfo;
   import gemstone.items.GemstoneContent;
   import gemstone.items.Item;
   import org.aswing.KeyboardManager;
   
   public class GemstoneCriView extends Sprite implements Disposeable
   {
      
      private static const ANGLE_P1:int = 90;
      
      private static const ANGLE_P2:int = 210;
      
      private static const ANGLE_P3:int = 330;
      
      private static const RADIUS:int = 38;
       
      
      private var maxLevel:int;
      
      public var data:GemstonInitInfo;
      
      public var staticDataList:Vector.<GemstoneStaticInfo>;
      
      public var place:int;
      
      private var _contArray:Vector.<GemstoneContent>;
      
      private var _centerP:Point;
      
      private var _item:Item;
      
      private var _point1:Point;
      
      private var _point2:Point;
      
      private var _point3:Point;
      
      private var _pointArray:Array;
      
      private var _startPointArr:Array;
      
      private var _funArray:Array;
      
      private var _func1:Function;
      
      private var _func2:Function;
      
      private var _func3:Function;
      
      private var _lightning:MovieClip;
      
      private var _bombo:MovieClip;
      
      private var _groudMc:MovieClip;
      
      private var _upGradeMc:MovieClip;
      
      private var _isLeft:Boolean = false;
      
      private var _index:int;
      
      private var _minGemstone:Array;
      
      private var _midGemstone:Array;
      
      private var _maxGemstone:Array;
      
      private var _curItem:GemstoneContent;
      
      public var curIndex:int;
      
      public var curInfo:GemstListInfo;
      
      public var curList:Vector.<GemstListInfo>;
      
      private var _info:GemstoneUpGradeInfo;
      
      private var _isAction:Boolean;
      
      private var curInfoList:Vector.<GemstListInfo>;
      
      private var PRICE:int = 10;
      
      public function GemstoneCriView()
      {
         var _loc2_:GemstoneContent = null;
         var _loc3_:Point = null;
         this.maxLevel = GemstoneManager.Instance.curMaxLevel;
         this._centerP = new Point(0,0);
         super();
         this._pointArray = [];
         this._startPointArr = [];
         this._funArray = [];
         this._contArray = new Vector.<GemstoneContent>();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = new GemstoneContent(_loc1_,this._centerP);
            _loc2_.id = _loc1_ + 1;
            addChild(_loc2_);
            this._contArray.push(_loc2_);
            _loc3_ = new Point(_loc2_.x,_loc2_.y);
            this._startPointArr.push(_loc3_);
            _loc1_++;
         }
         this._item = new Item();
         this._item.x = -105;
         this._item.y = -105;
         addChild(this._item);
         this._func1 = this.completedHander1;
         this._func2 = this.completedHander2;
         this._func3 = this.completedHander3;
         this._funArray.push(this._func1);
         this._funArray.push(this._func2);
         this._funArray.push(this._func3);
         this._point1 = new Point();
         this._point1.x = Math.round(this._centerP.x + Math.cos(ANGLE_P1 * (Math.PI / 180)) * RADIUS);
         this._point1.y = Math.round(this._centerP.y - Math.sin(ANGLE_P1 * (Math.PI / 180)) * RADIUS);
         this._pointArray.push(this._point1);
         this._point2 = new Point();
         this._point2.x = Math.round(this._centerP.x + Math.cos(ANGLE_P2 * (Math.PI / 180)) * RADIUS);
         this._point2.y = Math.round(this._centerP.y - Math.sin(ANGLE_P2 * (Math.PI / 180)) * RADIUS);
         this._pointArray.push(this._point2);
         this._point3 = new Point();
         this._point3.x = Math.round(this._centerP.x + Math.cos(ANGLE_P3 * (Math.PI / 180)) * RADIUS);
         this._point3.y = Math.round(this._centerP.y - Math.sin(ANGLE_P3 * (Math.PI / 180)) * RADIUS);
         this._pointArray.push(this._point3);
         this._lightning = ComponentFactory.Instance.creat("gemstone.shandian");
         this._lightning.x = -44;
         this._lightning.y = -38;
         this._lightning.gotoAndStop(this._lightning.totalFrames);
         this._lightning.visible = false;
         addChild(this._lightning);
         this._bombo = ComponentFactory.Instance.creat("gemstone.bombo");
         this._bombo.x = -76;
         this._bombo.y = -78;
         this._bombo.gotoAndStop(this._bombo.totalFrames);
         this._bombo.visible = false;
         addChild(this._bombo);
         this._groudMc = ComponentFactory.Instance.creat("gemstone.groudMC");
         this._groudMc.x = -39;
         this._groudMc.y = -32;
         this._groudMc.gotoAndStop(this._groudMc.totalFrames);
         this._groudMc.visible = false;
         addChild(this._groudMc);
         this._upGradeMc = ComponentFactory.Instance.creat("gemstone.upGradeMc");
         this._upGradeMc.gotoAndStop(this._upGradeMc.totalFrames);
         this._upGradeMc.x = -76;
         this._upGradeMc.y = 23;
         this._upGradeMc.visible = false;
         addChild(this._upGradeMc);
      }
      
      public function upDataIcon(param1:ItemTemplateInfo) : void
      {
         this._item.upDataIcon(param1);
      }
      
      public function initFigSkin(param1:String) : void
      {
         this._contArray[0].loadSikn(param1);
         this._contArray[1].loadSikn(param1);
         this._contArray[2].loadSikn(param1);
         this._contArray[0].selAlphe(0.4);
         this._contArray[1].selAlphe(0.4);
         this._contArray[2].selAlphe(0.4);
      }
      
      public function resetGemstoneList(param1:Vector.<GemstListInfo>) : void
      {
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this._contArray[_loc3_].x = this._startPointArr[_loc3_].x;
            this._contArray[_loc3_].y = this._startPointArr[_loc3_].y;
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            if(param1[_loc4_].place == 0)
            {
               this._contArray[0].info = param1[_loc4_];
               if(param1[_loc4_].level > 0)
               {
                  this._contArray[0].selAlphe(1);
               }
               else
               {
                  this._contArray[0].selAlphe(0.4);
               }
               this._contArray[0].upDataLevel();
            }
            else if(param1[_loc4_].place == 1)
            {
               this._contArray[1].info = param1[_loc4_];
               if(param1[_loc4_].level > 0)
               {
                  this._contArray[1].selAlphe(1);
               }
               else
               {
                  this._contArray[1].selAlphe(0.4);
               }
               this._contArray[1].upDataLevel();
            }
            else if(param1[_loc4_].place == 2)
            {
               this._contArray[2].info = param1[_loc4_];
               if(param1[_loc4_].level > 0)
               {
                  this._contArray[2].selAlphe(1);
               }
               else
               {
                  this._contArray[2].selAlphe(0.4);
               }
               this._contArray[2].upDataLevel();
               this.curInfo = param1[_loc4_];
               this._curItem = this._contArray[2];
            }
            _loc4_++;
         }
         this._item.updataInfo(param1);
         this.curIndex = this.curInfo.place;
         var _loc5_:int = this.curInfo.level;
         this.setCurInfo(param1[0].fightSpiritId,_loc5_);
         if(_loc5_ >= this.maxLevel)
         {
            _loc5_ = this.maxLevel;
            _loc6_ = this.staticDataList[_loc5_].Exp - this.staticDataList[_loc5_ - 1].Exp;
            GemstoneUpView(parent).expBar.initBar(_loc6_,_loc6_,true);
            return;
         }
         _loc5_++;
         _loc6_ = this.staticDataList[_loc5_].Exp - this.staticDataList[_loc5_ - 1].Exp;
         GemstoneUpView(parent).expBar.initBar(this.curInfo.exp,_loc6_);
      }
      
      private function setCurInfo(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Object = new Object();
         _loc3_.curLve = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt1") + param2;
         _loc3_.levHe = int(this._contArray[0].info.level) + int(this._contArray[1].info.level) + int(this._contArray[2].info.level);
         if(param1 == GemstoneManager.ID1)
         {
            _loc4_ = this.staticDataList[this._contArray[0].info.level].attack;
            _loc5_ = this.staticDataList[this._contArray[1].info.level].attack;
            _loc6_ = this.staticDataList[this._contArray[2].info.level].attack;
            if(param2 >= this.maxLevel)
            {
               param2 = this.maxLevel;
            }
            _loc3_.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[param2].attack;
         }
         else if(param1 == GemstoneManager.ID2)
         {
            _loc4_ = this.staticDataList[this._contArray[0].info.level].defence;
            _loc5_ = this.staticDataList[this._contArray[1].info.level].defence;
            _loc6_ = this.staticDataList[this._contArray[2].info.level].defence;
            if(param2 >= this.maxLevel)
            {
               param2 = this.maxLevel;
            }
            _loc3_.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[param2].defence;
         }
         else if(param1 == GemstoneManager.ID3)
         {
            _loc4_ = this.staticDataList[this._contArray[0].info.level].agility;
            _loc5_ = this.staticDataList[this._contArray[1].info.level].agility;
            _loc6_ = this.staticDataList[this._contArray[2].info.level].agility;
            if(param2 >= this.maxLevel)
            {
               param2 = this.maxLevel;
            }
            _loc3_.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[param2].agility;
         }
         else if(param1 == GemstoneManager.ID4)
         {
            _loc4_ = this.staticDataList[this._contArray[0].info.level].luck;
            _loc5_ = this.staticDataList[this._contArray[1].info.level].luck;
            _loc6_ = this.staticDataList[this._contArray[2].info.level].luck;
            if(param2 >= this.maxLevel)
            {
               param2 = this.maxLevel;
            }
            _loc3_.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[param2].luck;
         }
         else if(param1 == GemstoneManager.ID5)
         {
            _loc4_ = this.staticDataList[this._contArray[0].info.level].blood;
            _loc5_ = this.staticDataList[this._contArray[1].info.level].blood;
            _loc6_ = this.staticDataList[this._contArray[2].info.level].blood;
            if(param2 >= this.maxLevel)
            {
               param2 = this.maxLevel;
            }
            _loc3_.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[param2].blood;
         }
         _loc3_.proHe = _loc4_ + _loc5_ + _loc6_;
         (parent as GemstoneUpView).upDataCur(_loc3_);
      }
      
      public function upGradeAction(param1:GemstoneUpGradeInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1.list.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.notEquip"));
            GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
            KeyboardManager.getInstance().isStopDispatching = false;
            return;
         }
         this._info = param1;
         if(this._info.isMaxLevel)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.maxLevel"));
            GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
            return;
         }
         if(this.curInfo == null)
         {
            _loc2_ = 0;
         }
         else
         {
            _loc2_ = this.curInfo.level;
         }
         if(!param1.isUp)
         {
            if(!param1.isFall)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.notfit"));
               GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.upgradeExp",param1.num * this.PRICE));
            _loc5_ = 0;
            while(_loc5_ < 3)
            {
               if(param1.list[_loc5_].place == 2)
               {
                  if(this.curInfo)
                  {
                     GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
                     this.curInfo = param1.list[_loc5_];
                  }
                  else
                  {
                     this.curInfo = new GemstListInfo();
                     this.curInfo = param1.list[_loc5_];
                  }
                  break;
               }
               _loc5_++;
            }
            _loc2_++;
            if(_loc2_ >= this.maxLevel)
            {
               _loc2_ = this.maxLevel;
            }
            _loc6_ = this.staticDataList[_loc2_].Exp - this.staticDataList[_loc2_ - 1].Exp;
            GemstoneManager.Instance.expBar.initBar(this.curInfo.exp,_loc6_);
            return;
         }
         this._isLeft = true;
         this._isAction = true;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.succe"));
         this._curItem.info.level++;
         _loc2_ = this._curItem.info.level;
         this._curItem.upDataLevel();
         this._upGradeMc.visible = true;
         this._upGradeMc.gotoAndPlay(1);
         var _loc4_:int = this.staticDataList[_loc2_].Exp - this.staticDataList[_loc2_ - 1].Exp;
         GemstoneManager.Instance.expBar.initBar(_loc4_,_loc4_);
         addEventListener(Event.ENTER_FRAME,this.enterframeHander);
      }
      
      private function init() : void
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            this._contArray[_loc2_].x = this._startPointArr[_loc2_].x;
            this._contArray[_loc2_].y = this._startPointArr[_loc2_].y;
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            if(this._info.list[_loc3_].place == 0)
            {
               this._contArray[0].info = this._info.list[_loc3_];
               if(this._info.list[_loc3_].level > 0)
               {
                  this._contArray[0].selAlphe(1);
               }
               else
               {
                  this._contArray[0].selAlphe(0.4);
               }
               this._contArray[0].upDataLevel();
            }
            else if(this._info.list[_loc3_].place == 1)
            {
               this._contArray[1].info = this._info.list[_loc3_];
               if(this._info.list[_loc3_].level > 0)
               {
                  this._contArray[1].selAlphe(1);
               }
               else
               {
                  this._contArray[1].selAlphe(0.4);
               }
               this._contArray[1].upDataLevel();
            }
            else if(this._info.list[_loc3_].place == 2)
            {
               this._contArray[2].info = this._info.list[_loc3_];
               if(this._info.list[_loc3_].level > 0)
               {
                  this._contArray[2].selAlphe(1);
               }
               else
               {
                  this._contArray[2].selAlphe(0.4);
               }
               this._contArray[2].upDataLevel();
               this.curInfo = this._info.list[_loc3_];
            }
            _loc3_++;
         }
         this.curInfoList = this._info.list;
         var _loc4_:int = this.curInfo.level;
         this.setCurInfo(this.curInfo.fightSpiritId,_loc4_);
         this._item.updataInfo(this.curInfoList);
         _loc4_++;
         if(_loc4_ >= this.maxLevel)
         {
            _loc4_ = this.maxLevel;
         }
         var _loc5_:int = this.staticDataList[_loc4_].Exp - this.staticDataList[_loc4_ - 1].Exp;
         GemstoneManager.Instance.expBar.initBar(this.curInfo.exp,_loc5_);
         GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
      }
      
      public function gemstoAction() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = this._contArray.length;
         if(!this._isLeft)
         {
            if(this._contArray[0].x == this._startPointArr[2].x)
            {
               _loc3_ = 0;
               while(_loc3_ < 3)
               {
                  if(_loc3_ == 0)
                  {
                     _loc1_ = 1;
                  }
                  else if(_loc3_ == 1)
                  {
                     _loc1_ = 2;
                  }
                  else if(_loc3_ == 2)
                  {
                     _loc1_ = 0;
                  }
                  TweenLite.to(this._contArray[_loc3_],0.5,{
                     "x":this._pointArray[_loc1_].x,
                     "y":this._pointArray[_loc1_].y,
                     "onComplete":this._funArray[_loc3_]
                  });
                  _loc3_++;
               }
            }
            else if(this._contArray[0].x == this._startPointArr[1].x)
            {
               _loc4_ = 0;
               while(_loc4_ < 3)
               {
                  _loc1_ = _loc4_;
                  TweenLite.to(this._contArray[_loc4_],0.5,{
                     "x":this._pointArray[_loc1_].x,
                     "y":this._pointArray[_loc1_].y,
                     "onComplete":this._funArray[_loc4_]
                  });
                  _loc4_++;
               }
            }
            else if(this._contArray[0].x == this._startPointArr[0].x)
            {
               _loc5_ = 0;
               while(_loc5_ < 3)
               {
                  if(_loc5_ == 0)
                  {
                     _loc1_ = 2;
                  }
                  else if(_loc5_ == 1)
                  {
                     _loc1_ = 0;
                  }
                  else if(_loc5_ == 2)
                  {
                     _loc1_ = 1;
                  }
                  TweenLite.to(this._contArray[_loc5_],0.5,{
                     "x":this._pointArray[_loc1_].x,
                     "y":this._pointArray[_loc1_].y,
                     "onComplete":this._funArray[_loc5_]
                  });
                  _loc5_++;
               }
            }
            return;
         }
         if(this._contArray[0].x == this._startPointArr[0].x)
         {
            _loc6_ = 0;
            while(_loc6_ < 3)
            {
               _loc1_ = _loc6_;
               TweenLite.to(this._contArray[_loc6_],0.5,{
                  "x":this._pointArray[_loc1_].x,
                  "y":this._pointArray[_loc1_].y,
                  "onComplete":this._funArray[_loc6_]
               });
               _loc6_++;
            }
         }
         else if(this._contArray[0].x == this._startPointArr[1].x)
         {
            _loc7_ = 0;
            while(_loc7_ < 3)
            {
               _loc1_ = _loc7_ + 1;
               if(_loc1_ > 2)
               {
                  _loc1_ = 0;
               }
               TweenLite.to(this._contArray[_loc7_],0.5,{
                  "x":this._pointArray[_loc1_].x,
                  "y":this._pointArray[_loc1_].y,
                  "onComplete":this._funArray[_loc7_]
               });
               _loc7_++;
            }
         }
         else if(this._contArray[0].x == this._startPointArr[2].x)
         {
            _loc8_ = 0;
            while(_loc8_ < 3)
            {
               if(_loc8_ == 0)
               {
                  _loc1_ = 2;
               }
               else
               {
                  _loc1_ = _loc8_ - 1;
               }
               TweenLite.to(this._contArray[_loc8_],0.5,{
                  "x":this._pointArray[_loc1_].x,
                  "y":this._pointArray[_loc1_].y,
                  "onComplete":this._funArray[_loc8_]
               });
               _loc8_++;
            }
         }
      }
      
      private function completedHander1() : void
      {
         if(!this._isLeft)
         {
            if(this._contArray[0].x == this._pointArray[0].x)
            {
               TweenLite.to(this._contArray[0],0.5,{
                  "x":this._startPointArr[0].x,
                  "y":this._startPointArr[0].y,
                  "onComplete":this.lightningPlay
               });
            }
            else if(this._contArray[0].x == this._pointArray[2].x)
            {
               TweenLite.to(this._contArray[0],0.5,{
                  "x":this._startPointArr[2].x,
                  "y":this._startPointArr[2].y,
                  "onComplete":this.lightningPlay
               });
            }
            else if(this._contArray[0].x == this._pointArray[1].x)
            {
               TweenLite.to(this._contArray[0],0.5,{
                  "x":this._startPointArr[1].x,
                  "y":this._startPointArr[1].y,
                  "onComplete":this.lightningPlay
               });
            }
            return;
         }
         if(this._contArray[0].x == this._pointArray[0].x)
         {
            TweenLite.to(this._contArray[0],0.5,{
               "x":this._startPointArr[1].x,
               "y":this._startPointArr[1].y,
               "onComplete":this.lightningPlay
            });
         }
         else if(this._contArray[0].x == this._pointArray[1].x)
         {
            TweenLite.to(this._contArray[0],0.5,{
               "x":this._startPointArr[2].x,
               "y":this._startPointArr[2].y,
               "onComplete":this.lightningPlay
            });
         }
         else if(this._contArray[0].x == this._pointArray[2].x)
         {
            TweenLite.to(this._contArray[0],0.5,{
               "x":this._startPointArr[0].x,
               "y":this._startPointArr[0].y,
               "onComplete":this.lightningPlay
            });
         }
      }
      
      private function lightningPlay() : void
      {
         if(!this._lightning)
         {
            return;
         }
         this._lightning.visible = true;
         this._lightning.gotoAndPlay(1);
         SoundManager.instance.stop("169");
         SoundManager.instance.stop("170");
         SoundManager.instance.play("168");
      }
      
      private function enterframeHander(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._upGradeMc.currentFrame == this._upGradeMc.totalFrames - 1)
         {
            this._upGradeMc.visible = false;
            this._upGradeMc.gotoAndStop(this._upGradeMc.totalFrames);
            SoundManager.instance.stop("170");
            SoundManager.instance.play("169");
            _loc3_ = this._contArray.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(this._contArray[_loc4_].info.level > 0)
               {
                  this._contArray[_loc4_].selAlphe(1);
                  this._contArray[_loc4_].upDataLevel();
               }
               _loc4_++;
            }
            if(this._isAction)
            {
               this.gemstoAction();
            }
            else
            {
               _loc5_ = this.curInfo.level;
               if(_loc5_ >= this.maxLevel)
               {
                  _loc5_ = this.maxLevel;
                  _loc2_ = this.staticDataList[_loc5_].Exp - this.staticDataList[_loc5_ - 1].Exp;
                  GemstoneManager.Instance.expBar.initBar(_loc2_,_loc2_,true);
                  GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
                  return;
               }
               this.setCurInfo(this.curInfo.fightSpiritId,_loc5_);
               _loc5_++;
               _loc2_ = this.staticDataList[_loc5_].Exp - this.staticDataList[_loc5_ - 1].Exp;
               GemstoneManager.Instance.expBar.initBar(0,_loc2_);
               GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
            }
         }
         if(this._lightning.currentFrame == this._lightning.totalFrames - 1)
         {
            this._lightning.visible = false;
            this._lightning.gotoAndStop(this._lightning.totalFrames);
            this._bombo.visible = true;
            this._bombo.gotoAndPlay(1);
            this._groudMc.visible = true;
            this._groudMc.gotoAndPlay(1);
         }
         if(this._groudMc.currentFrame == this._groudMc.totalFrames - 1)
         {
            this._groudMc.visible = false;
            this._groudMc.gotoAndStop(this._groudMc.totalFrames);
            this.init();
            removeEventListener(Event.ENTER_FRAME,this.enterframeHander);
         }
         if(this._bombo.currentFrame == this._bombo.totalFrames - 1)
         {
            this._bombo.visible = false;
            this._bombo.gotoAndStop(this._bombo.totalFrames);
         }
      }
      
      private function completedHander2() : void
      {
         if(!this._isLeft)
         {
            if(this._contArray[0].x == this._pointArray[0].x)
            {
               TweenLite.to(this._contArray[1],0.5,{
                  "x":this._startPointArr[1].x,
                  "y":this._startPointArr[1].y
               });
            }
            else if(this._contArray[0].x == this._pointArray[2].x)
            {
               TweenLite.to(this._contArray[1],0.5,{
                  "x":this._startPointArr[0].x,
                  "y":this._startPointArr[0].y
               });
            }
            else if(this._contArray[0].x == this._pointArray[1].x)
            {
               TweenLite.to(this._contArray[1],0.5,{
                  "x":this._startPointArr[2].x,
                  "y":this._startPointArr[2].y
               });
            }
            return;
         }
         if(this._contArray[0].x == this._pointArray[0].x)
         {
            TweenLite.to(this._contArray[1],0.5,{
               "x":this._startPointArr[2].x,
               "y":this._startPointArr[2].y
            });
         }
         else if(this._contArray[0].x == this._pointArray[1].x)
         {
            TweenLite.to(this._contArray[1],0.5,{
               "x":this._startPointArr[0].x,
               "y":this._startPointArr[0].y
            });
         }
         else if(this._contArray[0].x == this._pointArray[2].x)
         {
            TweenLite.to(this._contArray[1],0.5,{
               "x":this._startPointArr[1].x,
               "y":this._startPointArr[1].y
            });
         }
      }
      
      private function completedHander3() : void
      {
         if(!this._isLeft)
         {
            if(this._contArray[0].x == this._pointArray[0].x)
            {
               TweenLite.to(this._contArray[2],0.5,{
                  "x":this._startPointArr[2].x,
                  "y":this._startPointArr[2].y
               });
            }
            else if(this._contArray[0].x == this._pointArray[2].x)
            {
               TweenLite.to(this._contArray[2],0.5,{
                  "x":this._startPointArr[1].x,
                  "y":this._startPointArr[1].y
               });
            }
            else if(this._contArray[0].x == this._pointArray[1].x)
            {
               TweenLite.to(this._contArray[2],0.5,{
                  "x":this._startPointArr[0].x,
                  "y":this._startPointArr[0].y
               });
            }
            return;
         }
         if(this._contArray[0].x == this._pointArray[0].x)
         {
            TweenLite.to(this._contArray[2],0.5,{
               "x":this._startPointArr[0].x,
               "y":this._startPointArr[0].y
            });
         }
         else if(this._contArray[0].x == this._pointArray[1].x)
         {
            TweenLite.to(this._contArray[2],0.5,{
               "x":this._startPointArr[1].x,
               "y":this._startPointArr[1].y
            });
         }
         else if(this._contArray[0].x == this._pointArray[2].x)
         {
            TweenLite.to(this._contArray[2],0.5,{
               "x":this._startPointArr[2].x,
               "y":this._startPointArr[2].y
            });
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:GemstoneContent = null;
         removeEventListener(Event.ENTER_FRAME,this.enterframeHander);
         if(this._lightning)
         {
            this._lightning.gotoAndStop(this._lightning.totalFrames);
         }
         ObjectUtils.disposeObject(this._lightning);
         this._lightning = null;
         if(this._bombo)
         {
            this._bombo.gotoAndStop(this._bombo.totalFrames);
         }
         ObjectUtils.disposeObject(this._bombo);
         this._bombo = null;
         if(this._groudMc)
         {
            this._groudMc.gotoAndStop(this._groudMc.totalFrames);
         }
         ObjectUtils.disposeObject(this._groudMc);
         this._groudMc = null;
         if(this._upGradeMc)
         {
            this._upGradeMc.gotoAndStop(this._upGradeMc.totalFrames);
         }
         ObjectUtils.disposeObject(this._upGradeMc);
         this._upGradeMc = null;
         for each(_loc1_ in this._contArray)
         {
            if(_loc1_)
            {
               TweenLite.killTweensOf(_loc1_,true);
            }
            ObjectUtils.disposeObject(_loc1_);
         }
         this._contArray = null;
         this.staticDataList = null;
         this.curInfoList = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
