/* MIT License
 *
 * Copyright (c) 2024 Azis Naufal
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * SPDX-License-Identifier: MIT
 */


[GtkTemplate (ui = "/com/oazisn/ScreenCast/window.ui")]
public class Screencast.Window : Adw.ApplicationWindow, Screencast.WindowView {

    [GtkChild]
    private unowned Gtk.Button btn_start;

    [GtkChild]
    private unowned Gtk.Button btn_stop;

    private Screencast.WindowController controller;

    public Window (Gtk.Application app) {
        Object (application: app);
        controller = new Screencast.WindowController(this);
        controller.init();
    }

    [GtkCallback]
    private void on_btn_start_clicked() {
        controller.start_screen_cast();
    }

    [GtkCallback]
    private void on_btn_stop_clicked() {
        controller.stop_screen_cast();
    }

    public void on_idle() {
        btn_stop.set_visible(false);
        btn_start.set_visible(true);
    }

    public void on_starting() {
        btn_stop.set_visible(false);
        btn_start.set_visible(false);
    }

    public void on_started() {
        btn_stop.set_visible(true);
        btn_start.set_visible(false);
    }

    public void on_error(string message) {

    }

    public Gtk.Window get_window() {
        return get_native() as Gtk.Window;
    }
}
