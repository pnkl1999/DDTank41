package totem.view
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class TotemLeftWindowChapterIcon extends Sprite implements Disposeable
   {
       
      
      private var _iconList:Vector.<Bitmap>;
      
      private var _iconSprite:Sprite;
      
      private var _icon:Bitmap;
      
      private var _tipView:TotemLeftWindowChapterTipView;
      
      public function TotemLeftWindowChapterIcon()
      {
         var _loc1_:Bitmap = null;
         super();
         this._iconList = new Vector.<Bitmap>();
         var _loc2_:int = 1;
         while(_loc2_ <= 5)
         {
            _loc1_ = new Bitmap(ClassUtils.CreatInstance("asset.totem.chapterIcon" + _loc2_),"auto",true);
            this._iconList.push(_loc1_);
            _loc2_++;
         }
         this._iconSprite = new Sprite();
         this._iconSprite.addEventListener(MouseEvent.MOUSE_OVER,this.showTip,false,0,true);
         this._iconSprite.addEventListener(MouseEvent.MOUSE_OUT,this.hideTip,false,0,true);
         addChild(this._iconSprite);
         this._tipView = new TotemLeftWindowChapterTipView();
         this._tipView.visible = false;
         LayerManager.Instance.addToLayer(this._tipView,LayerManager.GAME_TOP_LAYER);
      }
      
      public function show(param1:int) : void
      {
         if(this._icon && this._icon.parent)
         {
            this._icon.parent.removeChild(this._icon);
         }
         this._icon = this._iconList[param1 - 1];
         this._iconSprite.addChild(this._icon);
         this._tipView.show(param1);
      }
      
      private function showTip(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         _loc2_ = this.localToGlobal(new Point(this._iconSprite.width + 5,this._iconSprite.height / 2));
         this._tipView.x = _loc2_.x;
         this._tipView.y = _loc2_.y;
         this._tipView.visible = true;
      }
      
      private function hideTip(param1:MouseEvent) : void
      {
         this._tipView.visible = false;
      }
      
      public function dispose() : void
      {
         if(this._iconSprite)
         {
            this._iconSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
            this._iconSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
         }
         ObjectUtils.disposeAllChildren(this);
         this._iconList = null;
         this._iconSprite = null;
         this._icon = null;
         ObjectUtils.disposeObject(this._tipView);
         this._tipView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
