public interface Screencast.WindowView : Object {
    public abstract void on_idle();
    public abstract void on_starting();
    public abstract void on_started();
    public abstract void on_error(string message);
    public abstract Gtk.Window get_window();
}
