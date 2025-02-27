namespace Winform
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            this.Text = "Docker Demo";

            Label label = new Label();
            label.Text = "Hello from Windows Container!";
            label.AutoSize = true;
            label.Location = new System.Drawing.Point(50, 50);
            this.Controls.Add(label);
        }
    }
}
