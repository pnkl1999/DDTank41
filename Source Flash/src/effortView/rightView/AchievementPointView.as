package effortView.rightView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class AchievementPointView extends Sprite implements Disposeable
   {
       
      
      private var num_e0:int;
      
      private var num_e1:int;
      
      private var num_e0BG:ScaleFrameImage;
      
      private var num_e1BG:ScaleFrameImage;
      
      private var _bg:Bitmap;
      
      private var _value:int;
      
      private var _pos1:Point;
      
      private var _pos2:Point;
      
      private var _pos3:Point;
      
      public function AchievementPointView()
      {
         super();
         this._bg = ComponentFactory.Instance.creat("asset.Effort.AchievementPointBG");
         this._bg.smoothing = true;
         addChild(this._bg);
         this.num_e0BG = ComponentFactory.Instance.creat("effortView.AchievementPointView.numBG");
         addChild(this.num_e0BG);
         this.num_e1BG = ComponentFactory.Instance.creat("effortView.AchievementPointView.numBG");
         addChild(this.num_e1BG);
         this._pos1 = ComponentFactory.Instance.creatCustomObject("effortView.EffortIconView.AchievementPointPos");
         this._pos2 = ComponentFactory.Instance.creatCustomObject("effortView.EffortIconView.AchievementPointPosII");
         this._pos3 = ComponentFactory.Instance.creatCustomObject("effortView.EffortIconView.AchievementPointPosIII");
      }
      
      public function set value(param1:int) : void
      {
         this._value = param1;
         if(this._value >= 10)
         {
            this.num_e0BG.visible = true;
            this.num_e1BG.visible = true;
            this.num_e1 = this._value / 10 % 10;
            this.num_e1BG.setFrame(this.num_e1);
            this.num_e0 = this._value - this.num_e1 * 10;
            if(this.num_e0 == 0)
            {
               this.num_e0BG.setFrame(10);
            }
            else
            {
               this.num_e0BG.setFrame(this.num_e0);
            }
            this.num_e0BG.x = this._pos1.x;
            this.num_e0BG.y = this._pos1.y;
            this.num_e1BG.x = this._pos2.x;
            this.num_e1BG.y = this._pos2.y;
         }
         else
         {
            this.num_e1BG.visible = false;
            this.num_e0 = this._value;
            if(this.num_e0 == 0)
            {
               this.num_e0BG.setFrame(10);
            }
            else
            {
               this.num_e0BG.setFrame(this.num_e0);
            }
            this.num_e0BG.x = this._pos3.x;
            this.num_e0BG.y = this._pos3.y;
         }
      }
      
      public function dispose() : void
      {
         if(this.num_e0BG)
         {
            this.num_e0BG.dispose();
         }
         this.num_e0BG = null;
         if(this.num_e1BG)
         {
            this.num_e1BG.dispose();
         }
         this.num_e1BG = null;
         if(this._bg && this._bg.bitmapData)
         {
            this._bg.bitmapData.dispose();
         }
         this._bg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
