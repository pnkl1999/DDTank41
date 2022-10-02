package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionPropertyView extends Sprite implements Disposeable
   {
       
      
      private var _propertyCellList:Vector.<AvatarCollectionPropertyCell>;
      
      private var _rightArrow:Bitmap;
      
      private var _tip:AvatarCollectionPropertyTip;
      
      private var _tipSprite:Sprite;
      
      private var _completeStatus:int = -1;
      
      public function AvatarCollectionPropertyView()
      {
         super();
         this.x = 22;
         this.y = 252;
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:AvatarCollectionPropertyCell = null;
         this._propertyCellList = new Vector.<AvatarCollectionPropertyCell>();
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = new AvatarCollectionPropertyCell(_loc1_);
            _loc2_.x = int(_loc1_ / 4) * 110;
            _loc2_.y = _loc1_ % 4 * 25;
            addChild(_loc2_);
            this._propertyCellList.push(_loc2_);
            _loc1_++;
         }
         this._rightArrow = ComponentFactory.Instance.creatBitmap("asset.avatarColl.rightArrows");
         this._rightArrow.visible = false;
         addChild(this._rightArrow);
         this._tip = new AvatarCollectionPropertyTip();
         this._tip.visible = false;
         PositionUtils.setPos(this._tip,"avatarColl.propertyView.tipPos");
         addChild(this._tip);
         this._tipSprite = new Sprite();
         this._tipSprite.graphics.beginFill(16711680,0);
         this._tipSprite.graphics.drawRect(-15,-20,242,122);
         this._tipSprite.graphics.endFill();
         addChild(this._tipSprite);
      }
      
      private function initEvent() : void
      {
         this._tipSprite.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this._tipSprite.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         if(this._completeStatus == 0 || this._completeStatus == 1)
         {
            this._rightArrow.visible = true;
            this._tip.visible = true;
         }
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         this._rightArrow.visible = false;
         this._tip.visible = false;
      }
      
      public function refreshView(param1:AvatarCollectionUnitVo) : void
      {
         var _loc2_:AvatarCollectionPropertyCell = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1)
         {
            _loc3_ = param1.totalItemList.length;
            _loc4_ = param1.totalActivityItemCount;
            if(_loc4_ < _loc3_ / 2)
            {
               this._completeStatus = 0;
               this._tip.refreshView(param1,1);
            }
            else if(_loc4_ == _loc3_)
            {
               this._completeStatus = 2;
            }
            else
            {
               this._completeStatus = 1;
               this._tip.refreshView(param1,2);
            }
         }
         else
         {
            this._completeStatus = -1;
         }
         for each(_loc2_ in this._propertyCellList)
         {
            _loc2_.refreshView(param1,this._completeStatus);
         }
      }
      
      private function removeEvent() : void
      {
         this._tipSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this._tipSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._propertyCellList = null;
         this._rightArrow = null;
         this._tip = null;
         this._tipSprite = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
