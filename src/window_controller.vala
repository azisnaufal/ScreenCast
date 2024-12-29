public class Screencast.WindowController : Object {

    private Screencast.WindowView view;
    private Xdp.Portal portal;
    private Xdp.Session session;

    public WindowController (Screencast.WindowView view) {
        this.view = view;
        portal = new Xdp.Portal();
    }

    public void init() {
        view.on_idle();
    }

    public void start_screen_cast() {
        view.on_starting();

        // portal.create_remote_desktop_session(
        //     Xdp.DeviceType.KEYBOARD|Xdp.DeviceType.POINTER|Xdp.DeviceType.TOUCHSCREEN,
        //     Xdp.OutputType.MONITOR|Xdp.OutputType.VIRTUAL,
        //     Xdp.RemoteDesktopFlags.NONE,
        //     Xdp.CursorMode.EMBEDDED,
        //     null,
        //     callback
        // );

        portal.create_screencast_session.begin (
            Xdp.OutputType.MONITOR|Xdp.OutputType.VIRTUAL, // Select the output types: MONITOR, VIRTUAL or WINDOW
            Xdp.ScreencastFlags.NONE, // Whether the screencast allows MULTIPLE streams or not (NONE)
            Xdp.CursorMode.EMBEDDED, // Whether the cursor is EMBEDDED, HIDDEN or sent as METADATA
            NONE, // Whether the screencast should PERSIST, should be TRANSIENT, or NONE (do not persist)
            null, // Restore token. If a screencast configuration was made by the user, the token given should be put here to not show the dialog and immediately apply configurations
            null, // Cancellable. We're using none
            callback // Callback of the function in which we will receive the result of our petition
        );
    }

    public void stop_screen_cast() {
        session.close();
        view.on_idle();
    }

    private void callback (GLib.Object? obj, GLib.AsyncResult res) {
        try {
            session = portal.create_screencast_session.end (res); // A Xdp.Session will return to us if the petition was successful, and therefore we can start the screencast

            // https://valadoc.org/libportal/Xdp.Parent.html
            Xdp.Parent parent = Xdp.parent_new_gtk (view.get_window());
            session.start.begin (
                parent, // Xdp.Parent
                null, // Cancellable, we're using none
                session_callback // Callback of the session, in which we will receive if the start of the screencast was successful
            );

            session.closed.connect((t) => {
                view.on_idle();
            });
        }
        catch (Error e) {
            critical (e.message);
            view.on_error(e.message);
            view.on_idle();
        }
    }

    private void session_callback (GLib.Object? obj, GLib.AsyncResult res) {
        try {
            bool screencast_active = session.start.end (res); // A boolean if the Screencast request was successful

            if (screencast_active) {
                view.on_started();

                session.open_pipewire_remote();

                start_stream();

                // Here, you can open a Pipewire remote using Xdp.Session.open_pipewire_remote () to display your screencast
                // Later, close your session with Xdp.Session.close ()
                // Check the Xdp.Session docs to find more useful methods https://valadoc.org/libportal/Xdp.Session.html
            }
            else {
                view.on_error(_("Screencast failed to start"));
            }
        }
        catch (Error e) {
            critical (e.message);
            view.on_error(e.message);
            view.on_idle();
        }
    }

    private void start_stream() {

    }
}
       
