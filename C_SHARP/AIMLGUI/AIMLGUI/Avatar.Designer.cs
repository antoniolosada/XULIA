namespace XULIA
{
    partial class Avatar
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.imgAvatar = new System.Windows.Forms.PictureBox();
            this.lblContador = new System.Windows.Forms.Label();
            this.tmrAvatar = new System.Windows.Forms.Timer(this.components);
            this.tbTexto = new System.Windows.Forms.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this.imgAvatar)).BeginInit();
            this.SuspendLayout();
            // 
            // imgAvatar
            // 
            this.imgAvatar.Image = global::XULIA.Properties.Resources.Xulia_boca_cerrada;
            this.imgAvatar.Location = new System.Drawing.Point(1, 1);
            this.imgAvatar.Name = "imgAvatar";
            this.imgAvatar.Size = new System.Drawing.Size(876, 659);
            this.imgAvatar.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.imgAvatar.TabIndex = 2;
            this.imgAvatar.TabStop = false;
            // 
            // lblContador
            // 
            this.lblContador.AutoSize = true;
            this.lblContador.Location = new System.Drawing.Point(697, 440);
            this.lblContador.Name = "lblContador";
            this.lblContador.Size = new System.Drawing.Size(0, 13);
            this.lblContador.TabIndex = 3;
            // 
            // tmrAvatar
            // 
            this.tmrAvatar.Tick += new System.EventHandler(this.tmrAvatar_Tick);
            // 
            // tbTexto
            // 
            this.tbTexto.Location = new System.Drawing.Point(13, 547);
            this.tbTexto.Multiline = true;
            this.tbTexto.Name = "tbTexto";
            this.tbTexto.Size = new System.Drawing.Size(759, 137);
            this.tbTexto.TabIndex = 4;
            // 
            // Avatar
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(877, 660);
            this.Controls.Add(this.imgAvatar);
            this.Controls.Add(this.lblContador);
            this.Controls.Add(this.tbTexto);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.Name = "Avatar";
            this.Text = "Avatar";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Avatar_FormClosing);
            this.Load += new System.EventHandler(this.Avatar_Load);
            this.SizeChanged += new System.EventHandler(this.Avatar_SizeChanged);
            ((System.ComponentModel.ISupportInitialize)(this.imgAvatar)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox imgAvatar;
        private System.Windows.Forms.Label lblContador;
        private System.Windows.Forms.Timer tmrAvatar;
        private System.Windows.Forms.TextBox tbTexto;

    }
}