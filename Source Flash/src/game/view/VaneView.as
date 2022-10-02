package game.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   
   public class VaneView extends Sprite
   {
      
      public static const RandomVaneOffset:Number = 6;
      
      public static const RANDOW_COLORS:Array = [1710618,1514802,1712150,2493709,1713677,1838339,1842464,2170141,1054500,2630187];
      
      public static const RANDOW_COLORSII:Array = [[4667276,2429483],[11785,5647616],[401937,608599],[473932,6492176],[9178527,1316390],[2360854,7280322],[2185247,927056],[8724255,4076052],[1835158,4653109],[919557,7353207],[1644310,5703976],[149007,857625],[2499109,872256],[8519680,1328498],[5775151,3355404],[1326929,7150931]];
       
      
      private var _bmVaneTitle:Bitmap;
      
      private var _bmPreviousDirection:Bitmap;
      
      private var _bmPrevious:Bitmap;
      
      private var vane1_mc:MovieClip;
      
      private var mixedbgAccect:Shape;
      
      private var _lastWind:Number;
      
      private var mixedBg1:CheckCodeMixedBack;
      
      private var vane1PosX:Number = 0;
      
      private var vane2PosX:Number = -17.5;
      
      private var text1PosX:Number = 0;
      
      private var text2PosX:Number = 0;
      
      private var _vanePos:Point;
      
      private var _vanePos2:Point;
      
      private var _vaneTitlePos:Point;
      
      private var _vaneTitlePos2:Point;
      
      private var _vaneValuePos:Point;
      
      private var _vaneValuePos2:Point;
      
      private var _field:FilterFrameText;
      
      private var _vanePreviousGradientText:FilterFrameText;
      
      private var textGlowFilter:GlowFilter;
      
      private var textFilter:Array;
      
      private var _previousDirectionPos:Point;
      
      private var _valuePos1:Point;
      
      private var _valuePos2:Point;
      
      private var _zeroTxt:FilterFrameText;
      
      private var _windNumShape:Shape;
      
      public function VaneView()
      {
         super();
         this._vanePos = ComponentFactory.Instance.creatCustomObject("asset.game.vaneAssetPos");
         this._vanePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneAssetPos2");
         this._vaneTitlePos = ComponentFactory.Instance.creatCustomObject("asset.game.vaneTitleAssetPos");
         this._vaneTitlePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneTitleAssetPos2");
         this._vaneValuePos = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos");
         this._vaneValuePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos2");
         this._bmVaneTitle = ComponentFactory.Instance.creatBitmap("asset.game.vaneTitleAsset");
         addChild(this._bmVaneTitle);
         this._bmPrevious = ComponentFactory.Instance.creatBitmap("asset.game.vanePreviousAsset");
         this._bmPrevious.visible = false;
         addChild(this._bmPrevious);
         this._bmPreviousDirection = ComponentFactory.Instance.creatBitmap("asset.game.vanePreviousDirectionAsset");
         this._previousDirectionPos = new Point(this._bmPreviousDirection.x,this._bmPreviousDirection.y);
         this._bmPreviousDirection.visible = false;
         addChild(this._bmPreviousDirection);
         this._vanePreviousGradientText = ComponentFactory.Instance.creatComponentByStylename("asset.game.vanePreviousGradientTextAsset");
         this._vanePreviousGradientText.visible = false;
         addChild(this._vanePreviousGradientText);
         this._zeroTxt = ComponentFactory.Instance.creatComponentByStylename("asset.game.vaneZeroTextAsset");
         this.vane1_mc = ClassUtils.CreatInstance("asset.game.vaneAsset");
         this.vane1_mc.mouseChildren = this.vane1_mc.mouseEnabled = false;
         this.vane1_mc.x = this._vanePos.x;
         this.vane1_mc.y = this._vanePos.y;
         addChild(this.vane1_mc);
         this.mixedbgAccect = new Shape();
         this.mixedbgAccect.graphics.beginFill(16777215,1);
         this.mixedbgAccect.graphics.drawRect(0,0,20,20);
         this.mixedbgAccect.graphics.endFill();
         this.creatGraidenText();
         this.creatMixBg();
         mouseChildren = mouseEnabled = false;
      }
      
      private function creatMixBg() : void
      {
         this.mixedBg1 = new CheckCodeMixedBack(20,20,7238008);
         this.mixedBg1.x = 0;
         this.mixedBg1.y = 0;
         this.mixedBg1.mask = this.mixedbgAccect;
      }
      
      public function setUpCenter(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      private function getRandomVaneOffset() : Number
      {
         return Number(Math.random() * RandomVaneOffset - RandomVaneOffset / 2);
      }
      
      private function creatGraidenText() : void
      {
         this._field = ComponentFactory.Instance.creatComponentByStylename("asset.game.vaneGradientTextAsset");
         this._field.autoSize = TextFieldAutoSize.CENTER;
         this._valuePos1 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos");
         this._valuePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos2");
         this._windNumShape = new Shape();
         addChildAt(this._windNumShape,numChildren);
      }
      
      public function initialize() : void
      {
         this._lastWind = 11;
      }
      
      public function update(param1:Number, param2:Boolean = false, param3:Array = null) : void
      {
         if(param3 == null)
         {
            this._windNumShape.visible = false;
            param3 = new Array();
            param3 = [true,0,0,0];
         }
         else
         {
            this._windNumShape.visible = true;
         }
         if(this._lastWind != 11)
         {
            this.lastTurn(this._lastWind);
         }
         if(param2)
         {
            this._lastWind = param1;
         }
         if(param1 != 0)
         {
            this._bmVaneTitle.x = param1 > 0 ? Number(Number(this._vaneTitlePos2.x)) : Number(Number(this._vaneTitlePos.x));
         }
         this.vane1_mc.scaleX = param3[0] == true ? Number(Number(1)) : Number(Number(-1));
         this.vane1_mc.x = param3[0] == true ? Number(Number(this._vanePos2.x)) : Number(Number(this._vanePos.x));
         this._windNumShape.x = param3[0] == true ? Number(Number(this._vaneValuePos.x)) : Number(Number(this._vaneValuePos2.x));
         this._windNumShape.y = param3[0] == true ? Number(Number(this._vaneValuePos.y)) : Number(Number(this._vaneValuePos2.y));
         if(param3[1] == 0 && param3[2] == 0 && param3[3] == 0)
         {
            this._zeroTxt.x = this._windNumShape.x;
            this._zeroTxt.y = this._windNumShape.y;
            addChild(this._zeroTxt);
            this._windNumShape.visible = false;
            this._zeroTxt.visible = true;
         }
         else
         {
            this._windNumShape.visible = true;
            this._zeroTxt.visible = false;
            this.drawNum([param3[1],param3[2],param3[3]]);
         }
      }
      
      private function drawNum(param1:Array) : void
      {
         var _loc4_:BitmapData = null;
         var _loc5_:int = 0;
         var _loc2_:Graphics = this._windNumShape.graphics;
         _loc2_.clear();
         var _loc3_:Matrix = new Matrix();
         for each(_loc5_ in param1)
         {
            _loc4_ = WindPowerManager.Instance.getWindPicById(_loc5_);
            if(_loc4_)
            {
               _loc3_.tx = this._windNumShape.width;
               _loc2_.beginBitmapFill(_loc4_,_loc3_);
               _loc2_.drawRect(this._windNumShape.width,0,_loc4_.width,_loc4_.height);
               _loc2_.endFill();
            }
         }
      }
      
      private function setRandomPos() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = NaN;
         _loc1_ = this.getRandomVaneOffset();
         this.vane1_mc.x += _loc1_;
         this._windNumShape.x += _loc1_;
      }
      
      private function addZero(param1:Number) : String
      {
         var _loc2_:String = null;
         if(Math.ceil(param1) == param1 || Math.floor(param1) == param1)
         {
            _loc2_ = Math.abs(param1).toString() + ".0";
         }
         else
         {
            _loc2_ = Math.abs(param1).toString();
         }
         return _loc2_;
      }
      
      private function lastTurn(param1:Number) : void
      {
         this._bmPrevious.visible = true;
         this._bmPreviousDirection.visible = true;
         this._vanePreviousGradientText.visible = true;
         this._bmPreviousDirection.scaleX = param1 > 0 ? Number(Number(1)) : Number(Number(-1));
         this._bmPreviousDirection.x = param1 > 0 ? Number(Number(81)) : Number(Number(this._previousDirectionPos.x));
         this._vanePreviousGradientText.text = Math.abs(param1).toString();
      }
      
      public function dispose() : void
      {
         if(this._bmVaneTitle)
         {
            if(this._bmVaneTitle.parent)
            {
               this._bmVaneTitle.parent.removeChild(this._bmVaneTitle);
            }
            this._bmVaneTitle.bitmapData.dispose();
            this._bmVaneTitle = null;
         }
         if(this._bmPreviousDirection)
         {
            if(this._bmPreviousDirection.parent)
            {
               this._bmPreviousDirection.parent.removeChild(this._bmPreviousDirection);
            }
            this._bmPreviousDirection.bitmapData.dispose();
            this._bmPreviousDirection = null;
         }
         if(this._bmPrevious)
         {
            if(this._bmPrevious.parent)
            {
               this._bmPrevious.parent.removeChild(this._bmPrevious);
            }
            this._bmPrevious.bitmapData.dispose();
            this._bmPrevious = null;
         }
         this.vane1_mc.stop();
         removeChild(this.vane1_mc);
         this.vane1_mc = null;
         this.mixedbgAccect = null;
         this.mixedBg1.mask = null;
         this.mixedBg1 = null;
         ObjectUtils.disposeObject(this._windNumShape);
         this._windNumShape = null;
         if(this._zeroTxt)
         {
            ObjectUtils.disposeObject(this._zeroTxt);
         }
         this._zeroTxt = null;
         ObjectUtils.disposeObject(this._vanePreviousGradientText);
         this._vanePreviousGradientText = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
