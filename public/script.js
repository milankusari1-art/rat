document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('executorForm');
    const resultsDiv = document.getElementById('results');
    const loadingOverlay = document.getElementById('loadingOverlay');
    const submitBtn = form.querySelector('.submit-btn');

    form.addEventListener('submit', async (e) => {
        e.preventDefault();

        const code = document.getElementById('code').value.trim();
        const port = document.getElementById('port').value;

        if (!code) {
            addResult('Please enter script code', 'error');
            return;
        }

        submitBtn.disabled = true;
        loadingOverlay.classList.remove('hidden');

        try {
            const response = await fetch('/api/execute', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    code: code,
                    port: port
                })
            });

            const data = await response.json();

            if (data.success) {
                addResult(`✓ ${data.message}`, 'success');
                form.reset();
            } else {
                addResult(`✗ ${data.message}`, 'error');
            }
        } catch (error) {
            addResult(`✗ Network Error: ${error.message}`, 'error');
        } finally {
            submitBtn.disabled = false;
            loadingOverlay.classList.add('hidden');
        }
    });

    function addResult(message, type = 'info') {
        // Remove empty state
        const emptyState = resultsDiv.querySelector('.empty-state');
        if (emptyState) {
            emptyState.remove();
        }

        const timestamp = new Date().toLocaleTimeString();
        const resultItem = document.createElement('div');
        resultItem.className = `result-item ${type}`;
        resultItem.innerHTML = `
            <div class="result-timestamp">[${timestamp}]</div>
            <div>${message}</div>
        `;

        resultsDiv.insertBefore(resultItem, resultsDiv.firstChild);

        // Limit results to last 50
        while (resultsDiv.children.length > 50) {
            resultsDiv.removeChild(resultsDiv.lastChild);
        }

        // Auto scroll to top
        resultsDiv.scrollTop = 0;
    }
});
