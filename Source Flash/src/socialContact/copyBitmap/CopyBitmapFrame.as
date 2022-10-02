package socialContact.copyBitmap
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.DrawImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CopyBitmapFrame extends Sprite
   {
       
      
      private var _pointViewArr:Vector.<Sprite>;
      
      private var _areaView:Sprite;
      
      private var _bgView:Shape;
      
      private var _mode:CopyBitmapMode;
      
      private var _nowPonitView:Sprite;
      
      private var _copyOkBt:BaseButton;
      
      private var _copyCancelBt:BaseButton;
      
      private var _oldPoint:Point;
      
      public function CopyBitmapFrame(param1:CopyBitmapMode)
      {
         super();
         this._mode = param1;
         this._init();
         this._addStartEvt();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
      }
      
      private function _init() : void
      {
         this._pointViewArr = new Vector.<Sprite>();
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this._pointViewArr[_loc1_] = this._buildPointView();
            this._pointViewArr[_loc1_].buttonMode = true;
            _loc1_++;
         }
         this._bgView = new Shape();
         this._areaView = new Sprite();
         this._areaView.buttonMode = true;
         this._copyOkBt = ComponentFactory.Instance.creatComponentByStylename("CopyBitmap.copyOkBt");
         this._copyCancelBt = ComponentFactory.Instance.creatComponentByStylename("CopyBitmap.copyCanceBt");
         this._upDataView(new Event("*"));
      }
      
      private function _buildPointView() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16711935);
         _loc1_.graphics.drawRect(-5,-5,10,10);
         return _loc1_;
      }
      
      private function _addStartEvt() : void
      {
         this._mode.addEventListener(CopyBitmapMode.CHANGE_MODE,this._upDataView);
      }
      
      private function _stageStartDown(param1:MouseEvent) : void
      {
         this._mode.startX = this._mode.endX = StageReferance.stage.mouseX;
         this._mode.startY = this._mode.endY = StageReferance.stage.mouseY;
         this._mode.ponitID = 3;
         this._nowPonitView = this._pointViewArr[3];
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this._stageStartDown);
         this.addEventListener(Event.ENTER_FRAME,this._thisInFrame);
      }
      
      private function _stageStartUp(param1:MouseEvent) : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this._thisInFrame);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this._stageStartUp);
         this._addEvt();
      }
      
      private function _addEvt() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this._pointViewArr[_loc1_].addEventListener(MouseEvent.MOUSE_DOWN,this._pointViewDown);
            _loc1_++;
         }
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this._stageUp);
         this._copyCancelBt.addEventListener(MouseEvent.CLICK,this._clickCancelBt);
         this._copyOkBt.addEventListener(MouseEvent.CLICK,this._clickOkBt);
         this._areaView.addEventListener(MouseEvent.MOUSE_DOWN,this._areaViewDown);
         this._areaView.addEventListener(MouseEvent.MOUSE_UP,this._areaViewUp);
      }
      
      private function _areaViewDown(param1:MouseEvent) : void
      {
         this._oldPoint = new Point();
         this._oldPoint.x = StageReferance.stage.mouseX;
         this._oldPoint.y = StageReferance.stage.mouseY;
         this._areaView.addEventListener(Event.ENTER_FRAME,this._areaViewMove);
      }
      
      private function _areaViewUp(param1:MouseEvent) : void
      {
         this._areaView.removeEventListener(Event.ENTER_FRAME,this._areaViewMove);
      }
      
      private function _areaViewMove(param1:Event) : void
      {
         this._mode.startX += StageReferance.stage.mouseX - this._oldPoint.x;
         this._mode.endX += StageReferance.stage.mouseX - this._oldPoint.x;
         this._mode.startY += StageReferance.stage.mouseY - this._oldPoint.y;
         this._mode.endY += StageReferance.stage.mouseY - this._oldPoint.y;
         this._oldPoint.x = StageReferance.stage.mouseX;
         this._oldPoint.y = StageReferance.stage.mouseY;
      }
      
      private function _pointViewDown(param1:MouseEvent) : void
      {
         this._mode.ponitID = this._pointViewArr.indexOf(param1.currentTarget);
         this._nowPonitView = Sprite(param1.currentTarget);
         switch(this._mode.ponitID)
         {
            case 0:
               this._nowPonitView.startDrag(false,new Rectangle(this._nowPonitView.x,0,1,StageReferance.stage.height));
               break;
            case 1:
               this._nowPonitView.startDrag(false,new Rectangle(0,0,StageReferance.stage.width,StageReferance.stage.height));
               break;
            case 2:
               this._nowPonitView.startDrag(false,new Rectangle(0,this._nowPonitView.y,StageReferance.stage.width,1));
               break;
            case 3:
               this._nowPonitView.startDrag(false,new Rectangle(0,0,StageReferance.stage.width,StageReferance.stage.height));
               break;
            case 4:
               this._nowPonitView.startDrag(false,new Rectangle(this._nowPonitView.x,0,1,StageReferance.stage.height));
               break;
            case 5:
               this._nowPonitView.startDrag(false,new Rectangle(0,0,StageReferance.stage.width,StageReferance.stage.height));
               break;
            case 6:
               this._nowPonitView.startDrag(false,new Rectangle(0,this._nowPonitView.y,StageReferance.stage.width,1));
               break;
            case 7:
               this._nowPonitView.startDrag(false,new Rectangle(0,0,StageReferance.stage.width,StageReferance.stage.height));
         }
         this.addEventListener(Event.ENTER_FRAME,this._thisInFrame);
      }
      
      private function _thisInFrame(param1:Event) : void
      {
         switch(this._mode.ponitID)
         {
            case 0:
               this._mode.startY = StageReferance.stage.mouseY;
               break;
            case 1:
               this._mode.endX = StageReferance.stage.mouseX;
               this._mode.startY = StageReferance.stage.mouseY;
               break;
            case 2:
               this._mode.endX = StageReferance.stage.mouseX;
               break;
            case 3:
               this._mode.endX = StageReferance.stage.mouseX;
               this._mode.endY = StageReferance.stage.mouseY;
               break;
            case 4:
               this._mode.endY = StageReferance.stage.mouseY;
               break;
            case 5:
               this._mode.startX = StageReferance.stage.mouseX;
               this._mode.endY = StageReferance.stage.mouseY;
               break;
            case 6:
               this._mode.startX = StageReferance.stage.mouseX;
               break;
            case 7:
               this._mode.startX = StageReferance.stage.mouseX;
               this._mode.startY = StageReferance.stage.mouseY;
         }
      }
      
      private function _stageUp(param1:MouseEvent) : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this._thisInFrame);
         if(this._nowPonitView)
         {
            this._nowPonitView.stopDrag();
         }
      }
      
      private function _upDataView(param1:Event) : void
      {
         this._bgView.graphics.clear();
         this._bgView.graphics.beginFill(0,0.5);
         this._bgView.graphics.drawRect(0,0,this._mode.startX,StageReferance.stage.height);
         this._bgView.graphics.drawRect(this._mode.startX,0,this._mode.endX - this._mode.startX,this._mode.startY);
         this._bgView.graphics.drawRect(this._mode.startX,this._mode.endY,this._mode.endX - this._mode.startX,StageReferance.stage.height - this._mode.endY);
         this._bgView.graphics.drawRect(this._mode.endX,0,StageReferance.stage.width - this._mode.endX,StageReferance.stage.height);
         addChild(this._bgView);
         this._areaView.graphics.clear();
         this._areaView.graphics.beginFill(65535,1);
         this._areaView.graphics.drawRect(this._mode.startX,this._mode.startY,this._mode.endX - this._mode.startX,this._mode.endY - this._mode.startY);
         this._areaView.alpha = 0;
         addChild(this._areaView);
         this._pointViewArr[0].x = (this._mode.startX + this._mode.endX) / 2;
         this._pointViewArr[0].y = this._mode.startY;
         addChild(this._pointViewArr[0]);
         this._pointViewArr[1].x = this._mode.endX;
         this._pointViewArr[1].y = this._mode.startY;
         addChild(this._pointViewArr[1]);
         this._pointViewArr[2].x = this._mode.endX;
         this._pointViewArr[2].y = (this._mode.startY + this._mode.endY) / 2;
         addChild(this._pointViewArr[2]);
         this._pointViewArr[3].x = this._mode.endX;
         this._pointViewArr[3].y = this._mode.endY;
         addChild(this._pointViewArr[3]);
         this._pointViewArr[4].x = (this._mode.startX + this._mode.endX) / 2;
         this._pointViewArr[4].y = this._mode.endY;
         addChild(this._pointViewArr[4]);
         this._pointViewArr[5].x = this._mode.startX;
         this._pointViewArr[5].y = this._mode.endY;
         addChild(this._pointViewArr[5]);
         this._pointViewArr[6].x = this._mode.startX;
         this._pointViewArr[6].y = (this._mode.startY + this._mode.endY) / 2;
         addChild(this._pointViewArr[6]);
         this._pointViewArr[7].x = this._mode.startX;
         this._pointViewArr[7].y = this._mode.startY;
         addChild(this._pointViewArr[7]);
         this._copyCancelBt.x = this._mode.endX - this._copyCancelBt.width > this._mode.startX - this._copyCancelBt.width ? Number(Number(this._mode.endX - this._copyCancelBt.width)) : Number(Number(this._mode.startX - this._copyCancelBt.width));
         this._copyCancelBt.y = this._mode.endY + this._copyCancelBt.height / 2 > this._mode.startY + this._copyCancelBt.height / 2 ? Number(Number(this._mode.endY + this._copyCancelBt.height / 2)) : Number(Number(this._mode.startY + this._copyCancelBt.height / 2));
         addChild(this._copyCancelBt);
         this._copyOkBt.x = this._copyCancelBt.x - this._copyOkBt.width;
         this._copyOkBt.y = this._copyCancelBt.y;
         addChild(this._copyOkBt);
      }
      
      private function _clickCancelBt(param1:MouseEvent) : void
      {
         CopyBitmapManager.Instance.close();
      }
      
      private function _clickOkBt(param1:MouseEvent) : void
      {
         this.visible = false;
         CopyBitmapManager.Instance.saveBmp();
      }
      
      public function dispose() : void
      {
         if(this._areaView)
         {
            removeChild(this._areaView);
         }
         this._areaView = null;
         if(this._bgView)
         {
            removeChild(this._bgView);
         }
         this._bgView = null;
         this._nowPonitView = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._pointViewArr.length)
         {
            if(this._pointViewArr[_loc1_] != null)
            {
               removeChild(this._pointViewArr[_loc1_]);
            }
            this._pointViewArr[_loc1_] = null;
            _loc1_++;
         }
         this._pointViewArr = null;
         if(this._copyOkBt)
         {
            ObjectUtils.disposeObject(this._copyOkBt);
         }
         this._copyOkBt = null;
         if(this._copyCancelBt)
         {
            ObjectUtils.disposeObject(this._copyCancelBt);
         }
         this._copyCancelBt = null;
      }
      
      private function kelisTest() : void
      {
         var kelis:DrawImage = null;
         kelis = null;
         var clickKelis:Function = null;
         clickKelis = function(param1:MouseEvent):void
         {
            kelis.ellipseWidth += 10;
         };
         kelis = ComponentFactory.Instance.creat("kelisImage");
         addChild(kelis);
         kelis.addEventListener(MouseEvent.CLICK,clickKelis);
      }
   }
}
