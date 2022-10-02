package game.view.prop
{
   import bagAndInfo.cell.DragEffect;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightPropMode;
   import ddt.data.PropInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.interfaces.IDragable;
   import ddt.manager.BitmapManager;
   import ddt.manager.DragManager;
   import ddt.manager.SharedManager;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.aswing.KeyboardManager;
   
   public class PropCell extends Sprite implements Disposeable, ITipedDisplay, IDragable, IAcceptDrag
   {
       
      
      protected var _x:int;
      
      protected var _y:int;
      
      protected var _enabled:Boolean = true;
      
      protected var _info:PropInfo;
      
      protected var _asset:DisplayObject;
      
      protected var _isExist:Boolean;
      
      protected var _back:DisplayObject;
      
      protected var _fore:DisplayObject;
      
      protected var _shortcutKey:String;
      
      protected var _shortcutKeyShape:DisplayObject;
      
      protected var _tipInfo:ToolPropInfo;
      
      protected var _tweenMax:TweenLite;
      
      protected var _localVisible:Boolean = true;
      
      protected var _mode:int;
      
      protected var _bitmapMgr:BitmapManager;
      
      private var _allowDrag:Boolean;
      
      private var _grayFilters:Array;
      
      public function PropCell(param1:String = null, param2:int = -1, param3:Boolean = false)
      {
         super();
         this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
         this._shortcutKey = param1;
         this._grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._mode = param2;
         mouseChildren = false;
         this._allowDrag = param3;
         this.configUI();
         this.addEvent();
      }
      
      public function get shortcutKey() : String
      {
         return this._shortcutKey;
      }
      
      public function setGrayFilter() : void
      {
         filters = this._grayFilters;
      }
      
      public function dragStart() : void
      {
         if(this._info && this._allowDrag)
         {
            if(this._enabled)
            {
               DragManager.startDrag(this,this._info,this._asset,stage.mouseX,stage.mouseY,"none",false,true,false,false,true);
            }
            else
            {
               this._asset.filters = this._grayFilters;
               DragManager.startDrag(this,this._info,this._asset,stage.mouseX,stage.mouseY,"none",false,true,false,false,true);
            }
         }
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         KeyboardManager.getInstance().isStopDispatching = false;
         if(param1.target == null || param1.target is PropCell == false)
         {
            this.info = this._info;
         }
         var _loc2_:PropCell = param1.target as PropCell;
         var _loc3_:PropInfo = _loc2_.info;
         var _loc4_:Boolean = _loc2_._enabled;
         var _loc5_:int = SharedManager.Instance.GameKeySets[_loc2_.shortcutKey];
         _loc2_.info = this.info;
         SharedManager.Instance.GameKeySets[_loc2_.shortcutKey] = SharedManager.Instance.GameKeySets[this.shortcutKey];
         this.info = _loc3_;
         SharedManager.Instance.GameKeySets[this.shortcutKey] = _loc5_;
         SharedManager.Instance.save();
         _loc2_.enabled = this.enabled;
         this.enabled = _loc4_;
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         if(this._allowDrag)
         {
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function get tipData() : Object
      {
         return this._tipInfo;
      }
      
      public function set tipData(param1:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "5,2,7,1,6,4";
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 20;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 20;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "core.ToolPropTips";
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
      
      protected function configUI() : void
      {
         this._back = this._bitmapMgr.creatBitmapShape("asset.game.prop.ItemBack",null,false,true);
         addChild(this._back);
         this._fore = this._bitmapMgr.creatBitmapShape("asset.game.prop.ItemFore",null,false,true);
         this._fore.y = 2;
         this._fore.x = 2;
         addChild(this._fore);
         if(this._shortcutKey != null)
         {
            this._shortcutKeyShape = ComponentFactory.Instance.creatBitmap("asset.game.prop.ShortcutKey" + this._shortcutKey);
            Bitmap(this._shortcutKeyShape).smoothing = true;
            this._shortcutKeyShape.y = -2;
            addChild(this._shortcutKeyShape);
         }
         this._tipInfo = new ToolPropInfo();
         this._tipInfo.showThew = true;
         this.drawLayer();
      }
      
      protected function drawLayer() : void
      {
         if(this._shortcutKey == null)
         {
            return;
         }
         if(this._mode == FightPropMode.VERTICAL)
         {
            this._shortcutKeyShape.x = 36 - this._shortcutKeyShape.width;
         }
         else
         {
            this._shortcutKeyShape.x = 0;
         }
      }
      
      protected function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      protected function __mouseOut(param1:MouseEvent) : void
      {
         x = this._x;
         y = this._y;
         scaleX = scaleY = 1;
         if(this._shortcutKey != null)
         {
            this._shortcutKeyShape.scaleX = this._shortcutKeyShape.scaleY = 1;
         }
         if(this._tweenMax)
         {
            this._tweenMax.pause();
         }
         if(this._enabled)
         {
            filters = null;
         }
         else
         {
            filters = this._grayFilters;
         }
      }
      
      protected function __mouseOver(param1:MouseEvent) : void
      {
         if(this._info != null)
         {
            if(this._shortcutKey != null)
            {
               this._shortcutKeyShape.scaleX = this._shortcutKeyShape.scaleY = 0.9;
            }
            x = this._x - 3.6;
            y = this._y - 3.6;
            scaleX = scaleY = 1.2;
            if(this.enabled)
            {
               if(this._tweenMax == null)
               {
                  this._tweenMax = TweenMax.to(this,0.5,{
                     "repeat":-1,
                     "yoyo":true,
                     "glowFilter":{
                        "color":16777011,
                        "alpha":1,
                        "blurX":4,
                        "blurY":4,
                        "strength":3
                     }
                  });
               }
               this._tweenMax.play();
            }
            if(parent)
            {
               parent.setChildIndex(this,parent.numChildren - 1);
            }
         }
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function get info() : PropInfo
      {
         return this._info;
      }
      
      public function setMode(param1:int) : void
      {
         this._mode = param1;
         this.drawLayer();
      }
      
      public function set info(param1:PropInfo) : void
      {
         var _loc3_:Bitmap = null;
         //_loc3_ = null;
         ShowTipManager.Instance.removeTip(this);
         this._info = param1;
         var _loc2_:DisplayObject = this._asset;
         if(this._info != null)
         {
			_loc3_ = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop" + this._info.Template.Pic + "Asset")
            if(_loc3_)
            {
               _loc3_.smoothing = true;
               _loc3_.x = _loc3_.y = 1;
               _loc3_.width = _loc3_.height = 35;
               addChildAt(_loc3_,getChildIndex(this._fore));
            }
            this._asset = _loc3_;
            this._tipInfo.info = this._info.Template;
            this._tipInfo.shortcutKey = this._shortcutKey;
            ShowTipManager.Instance.addTip(this);
            buttonMode = true;
         }
         else
         {
            buttonMode = false;
         }
         if(_loc2_ != null)
         {
            ObjectUtils.disposeObject(_loc2_);
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            if(!this._enabled)
            {
               filters = this._grayFilters;
            }
            else
            {
               filters = null;
            }
         }
      }
      
      public function get isExist() : Boolean
      {
         return this._isExist;
      }
      
      public function set isExist(param1:Boolean) : void
      {
         this._isExist = param1;
      }
      
      public function setPossiton(param1:int, param2:int) : void
      {
         this._x = param1;
         this._y = param2;
         this.x = this._x;
         this.y = this._y;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ShowTipManager.Instance.removeTip(this);
         filters = null;
         if(this._tweenMax)
         {
            this._tweenMax.kill();
         }
         this._tweenMax = null;
         ObjectUtils.disposeObject(this._asset);
         this._asset = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._fore);
         this._fore = null;
         ObjectUtils.disposeObject(this._shortcutKeyShape);
         this._shortcutKeyShape = null;
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         TweenLite.killTweensOf(this);
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function useProp() : void
      {
         if(this._localVisible)
         {
            dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      public function get localVisible() : Boolean
      {
         return this._localVisible;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         if(this._localVisible != param1)
         {
            this._localVisible = param1;
         }
      }
   }
}
